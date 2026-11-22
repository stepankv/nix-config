import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class SshScriptsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="ssh-script-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.home = self.root / "local home"
        self.bin = self.root / "bin"
        for directory in (self.home, self.bin):
            directory.mkdir()
        self.log = self.root / "commands.jsonl"
        self.vault = self.root / "vault.json"
        self.env = {
            **os.environ,
            "HOME": str(self.home),
            "SSH_KEY_PROFILE": "homestation",
            "PATH": f"{self.bin}:{os.environ['PATH']}",
            "TEST_LOG": str(self.log),
            "TEST_VAULT": str(self.vault),
        }
        self.env.pop("BW_SESSION", None)
        self.key = self.make_key("ed25519")
        self.items = [
            {
                "name": f"urn:ssh-key:{profile}:{service}:auth",
                "type": 5,
                "sshKey": {"privateKey": self.key},
            }
            for profile in ("homestation", "macos")
            for service in ("github", "gitlab")
        ]
        self.mock("bw", '''
import json, os, signal, sys
from pathlib import Path
with open(os.environ["TEST_LOG"], "a") as log:
    log.write(json.dumps(["bw", *sys.argv[1:]]) + "\\n")
command = sys.argv[1]
if command == "unlock":
    if os.environ.get("TEST_UNLOCK_FAILURE"):
        sys.exit(5)
    print("test-session")
else:
    assert os.environ.get("BW_SESSION") == "test-session"
    if command == "list":
        assert sys.argv[2:4] == ["items", "--search"]
        urn = sys.argv[4]
        items = json.loads(Path(os.environ["TEST_VAULT"]).read_text())
        print(json.dumps([item for item in items if urn in item["name"]]))
        if os.environ.get("TEST_FETCH_FAILURE"):
            sys.exit(1)
    elif command == "sync":
        if os.environ.get("TEST_SYNC_FAILURE"):
            sys.exit(7)
        if os.environ.get("TEST_TERMINATE"):
            os.kill(os.getppid(), signal.SIGTERM)
    else:
        assert command == "lock"
        if os.environ.get("TEST_LOCK_FAILURE"):
            sys.exit(23)
''')

    def make_key(self, kind, passphrase=""):
        path = self.root / f"fixture-{kind}-{bool(passphrase)}"
        subprocess.run(
            ["ssh-keygen", "-q", "-t", kind, "-N", passphrase, "-f", str(path)],
            check=True, capture_output=True,
        )
        return path.read_text()

    def mock(self, name, body):
        path = self.bin / name
        path.write_text("#!/usr/bin/env python3\n" + body)
        path.chmod(0o755)

    def run_script(self, script, *arguments, success=True):
        self.vault.write_text(json.dumps(self.items))
        result = subprocess.run(
            ["bash", str(ROOT / "scripts" / f"ssh-{script}.sh"), *arguments],
            env=self.env, text=True, capture_output=True, timeout=15,
        )
        self.assertEqual(result.returncode == 0, success, result.stderr)
        self.assertNotIn(self.key.strip(), result.stdout + result.stderr)
        return result

    def commands(self):
        if not self.log.exists():
            return []
        return [json.loads(line) for line in self.log.read_text().splitlines()]

    def assert_pair(self, home, service):
        directory = home / ".ssh"
        private = directory / service
        public = directory / f"{service}.pub"
        self.assertEqual(private.read_text(), self.key)
        derived = subprocess.check_output(
            ["ssh-keygen", "-y", "-P", "", "-f", str(private)], text=True,
        )
        self.assertEqual(public.read_text(), derived)
        self.assertEqual(directory.stat().st_mode & 0o777, 0o700)
        self.assertEqual(private.stat().st_mode & 0o777, 0o600)
        self.assertEqual(public.stat().st_mode & 0o777, 0o644)
        self.assertEqual(list(directory.glob(".key.*")), [])

    def test_restore_all_and_repeat_without_bitwarden(self):
        self.run_script("restore", "all")
        for service in ("github", "gitlab"):
            self.assert_pair(self.home, service)
        self.assertEqual(sum(cmd[1] == "unlock" for cmd in self.commands()), 1)
        self.assertEqual(sum(cmd[1] == "lock" for cmd in self.commands()), 1)
        self.assertEqual(self.commands()[-1], ["bw", "lock"])
        self.log.unlink()
        self.run_script("restore", "all")
        self.assertEqual(self.commands(), [])

    def test_restore_one_macos_key(self):
        self.env["SSH_KEY_PROFILE"] = "macos"
        self.run_script("restore", "gitlab")
        self.assert_pair(self.home, "gitlab")
        self.assertIn(
            ["bw", "list", "items", "--search", "urn:ssh-key:macos:gitlab:auth"],
            self.commands(),
        )
        self.assertFalse((self.home / ".ssh/github").exists())

    def test_incomplete_pair_stops_before_unlock(self):
        directory = self.home / ".ssh"
        directory.mkdir()
        (directory / "gitlab.pub").write_text("existing")
        self.run_script("restore", "all", success=False)
        self.assertEqual(self.commands(), [])
        self.assertEqual((directory / "gitlab.pub").read_text(), "existing")
        self.assertFalse((directory / "github").exists())

    def test_symlink_is_not_overwritten(self):
        directory = self.home / ".ssh"
        directory.mkdir()
        (directory / "github").symlink_to(self.root / "missing")
        self.run_script("restore", "github", success=False)
        self.assertTrue((directory / "github").is_symlink())
        self.assertEqual(self.commands(), [])

    def test_ssh_directory_symlink_is_rejected(self):
        directory = self.root / "ssh directory"
        directory.mkdir()
        (self.home / ".ssh").symlink_to(directory, target_is_directory=True)
        self.run_script("restore", "github", success=False)
        self.assertEqual(self.commands(), [])

    def test_invalid_profiles_and_arguments_do_not_unlock(self):
        for profile in ("", "unknown"):
            self.env["SSH_KEY_PROFILE"] = profile
            self.run_script("restore", "github", success=False)
        self.env["SSH_KEY_PROFILE"] = "homestation"
        for args in ((), ("unknown",)):
            self.run_script("restore", *args, success=False)
        self.assertEqual(self.commands(), [])

    def test_duplicate_missing_wrong_type_and_empty_items_fail(self):
        original = self.items[0]
        for items in (
            [original, original], [],
            [{**original, "type": 1}],
            [{**original, "sshKey": {"privateKey": ""}}],
            [{**original, "name": original["name"] + "-extra"}],
        ):
            self.items = items
            self.run_script("restore", "github", success=False)
            self.assertFalse((self.home / ".ssh/github").exists())

    def test_invalid_encrypted_and_non_ed25519_keys_leave_no_files(self):
        for key in ("invalid", self.make_key("ed25519", "secret"), self.make_key("ecdsa")):
            self.items[0]["sshKey"]["privateKey"] = key
            self.run_script("restore", "github", success=False)
            self.assertEqual(list((self.home / ".ssh").iterdir()), [])

    def test_fetch_failure_after_output_does_not_install(self):
        self.env["TEST_FETCH_FAILURE"] = "1"
        self.run_script("restore", "github", success=False)
        self.assertFalse((self.home / ".ssh/github").exists())
        self.assertEqual(self.commands()[-1], ["bw", "lock"])

    def test_vault_locks_after_invalid_key(self):
        self.items[0]["sshKey"]["privateKey"] = "invalid"
        self.run_script("restore", "github", success=False)
        self.assertEqual(self.commands()[-1], ["bw", "lock"])
        self.assertEqual(sum(cmd[1] == "lock" for cmd in self.commands()), 1)

    def test_vault_locks_after_sync_failure_and_preserves_exit_code(self):
        self.env["TEST_SYNC_FAILURE"] = "1"
        result = self.run_script("restore", "github", success=False)
        self.assertEqual(result.returncode, 7)
        self.assertEqual(self.commands(), [["bw", "unlock", "--raw"], ["bw", "sync"], ["bw", "lock"]])

    def test_vault_does_not_lock_after_unlock_failure(self):
        self.env["TEST_UNLOCK_FAILURE"] = "1"
        result = self.run_script("restore", "github", success=False)
        self.assertEqual(result.returncode, 5)
        self.assertEqual(self.commands(), [["bw", "unlock", "--raw"]])

    def test_vault_locks_on_termination(self):
        self.env["TEST_TERMINATE"] = "1"
        result = self.run_script("restore", "github", success=False)
        self.assertEqual(result.returncode, 143)
        self.assertEqual(self.commands()[-1], ["bw", "lock"])
        self.assertEqual(sum(cmd[1] == "lock" for cmd in self.commands()), 1)

    def test_lock_failure_is_reported(self):
        self.env["TEST_LOCK_FAILURE"] = "1"
        result = self.run_script("restore", "github", success=False)
        self.assertEqual(result.returncode, 1)
        self.assertIn("Failed to lock Bitwarden vault", result.stderr)
        self.assert_pair(self.home, "github")

    def test_lock_failure_preserves_original_failure(self):
        self.env["TEST_SYNC_FAILURE"] = "1"
        self.env["TEST_LOCK_FAILURE"] = "1"
        result = self.run_script("restore", "github", success=False)
        self.assertEqual(result.returncode, 7)
        self.assertIn("Failed to lock Bitwarden vault", result.stderr)

    def test_failed_public_link_rolls_back_private_link(self):
        real_ln = subprocess.check_output(["sh", "-c", "command -v ln"], text=True).strip()
        self.mock("ln", f'''
import os, sys
if sys.argv[2].endswith(".pub"):
    sys.exit(1)
os.execv({real_ln!r}, [{real_ln!r}, *sys.argv[1:]])
''')
        self.run_script("restore", "github", success=False)
        self.assertEqual(list((self.home / ".ssh").iterdir()), [])


if __name__ == "__main__":
    unittest.main()

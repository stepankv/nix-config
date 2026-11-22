#!/usr/bin/env bash

set -euo pipefail
set +x
umask 077

error() {
    printf '%s\n' "$*" >&2
    exit 1
}

require_trusted_profile() {
    case "${SSH_KEY_PROFILE:-}" in
        homestation | macos) ;;
        *) error "SSH_KEY_PROFILE must be homestation or macos" ;;
    esac
}

# Invoked by the EXIT trap.
# shellcheck disable=SC2329
lock_vault() {
    local status=$?
    trap - EXIT INT TERM
    if ! bw lock >/dev/null; then
        printf '%s\n' "Failed to lock Bitwarden vault" >&2
        if ((status == 0)); then status=1; fi
    fi
    unset BW_SESSION
    exit "$status"
}

unlock_vault() {
    unset BW_SESSION
    BW_SESSION="$(bw unlock --raw)"
    [[ -n "$BW_SESSION" ]] || error "Bitwarden returned an empty session"
    export BW_SESSION
    trap lock_vault EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM
    bw sync >/dev/null
}

read_private_key() {
    local urn="$1"
    bw list items --search "$urn" |
        jq -er --arg urn "$urn" '
            [.[] | select(.name == $urn)] |
            if length != 1 then
                error("Expected exactly one Bitwarden item named " + $urn)
            elif .[0].type != 5 then
                error("Expected an SSH Key item named " + $urn)
            else
                .[0].sshKey.privateKey |
                if type == "string" and length > 0 then .
                else error("SSH private key is empty") end
            end
        '
}

install_ssh_key() (
    set -euo pipefail
    set +x
    umask 077

    local service="$1" dir="$HOME/.ssh" target tmp key_type
    case "$service" in
        github | gitlab) ;;
        *) error "Unsupported service: $service" ;;
    esac

    [[ ! -L "$dir" ]] || error "Refusing symlink: $dir"
    mkdir -p "$dir"
    chmod 700 "$dir"
    target="$dir/$service"
    if [[ -e "$target" || -L "$target" || -e "$target.pub" || -L "$target.pub" ]]; then
        error "Key already exists: $service"
    fi

    tmp="$(mktemp -d "$dir/.key.XXXXXXXX")"

    # Invoked by the EXIT trap.
    # shellcheck disable=SC2329
    cleanup_key() {
        local status=$?
        if ((status != 0)); then
            # Roll back only links created from this temporary pair.
            if [[ "$target" -ef "$tmp/private" ]]; then rm -f "$target"; fi
            if [[ "$target.pub" -ef "$tmp/public" ]]; then rm -f "$target.pub"; fi
        fi
        rm -f "$tmp/private" "$tmp/public"
        rmdir "$tmp"
    }

    trap cleanup_key EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM

    cat >"$tmp/private"
    chmod 600 "$tmp/private"
    ssh-keygen -y -P "" -f "$tmp/private" >"$tmp/public"
    read -r key_type _ <"$tmp/public"
    [[ "$key_type" == ssh-ed25519 ]] || error "Expected an Ed25519 key"
    chmod 644 "$tmp/public"

    # Hard links install staged files without overwriting existing files.
    ln "$tmp/private" "$target"
    ln "$tmp/public" "$target.pub"
)

main() {
    local ssh_dir="$HOME/.ssh" name private public urn key
    local -a services missing=()

    require_trusted_profile

    if (($# != 1)); then
        error "Usage: just ssh-restore <github|gitlab|all>"
    fi
    case "$1" in
        github | gitlab) services=("$1") ;;
        all) services=(github gitlab) ;;
        *) error "Unsupported service: $1" ;;
    esac

    [[ ! -L "$ssh_dir" ]] || error "Refusing symlink: $ssh_dir"
    for name in "${services[@]}"; do
        private="$ssh_dir/$name"
        public="$private.pub"
        if [[ -f "$private" && ! -L "$private" && -f "$public" && ! -L "$public" ]]; then
            echo "Already installed: $name"
        elif [[ -e "$private" || -L "$private" || -e "$public" || -L "$public" ]]; then
            error "Incomplete key pair or unsupported file: $name"
        else
            missing+=("$name")
        fi
    done

    ((${#missing[@]} > 0)) || return 0
    unlock_vault
    for name in "${missing[@]}"; do
        urn="urn:ssh-key:$SSH_KEY_PROFILE:$name:auth"
        echo "Restoring $urn"
        # Finish fetching before starting installation, so a failed fetch cannot install a key.
        key="$(read_private_key "$urn")"
        printf '%s\n' "$key" | install_ssh_key "$name"
        unset key
        echo "Installed: $name"
    done
}

main "$@"

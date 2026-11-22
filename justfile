set shell := ["bash", "-uc"]

[doc("List available recipes")]
default:
    @just --list

[arg("inputs", help="Input names to update; omit to update all inputs")]
[doc("Update flake inputs")]
update *inputs:
    nix flake update {{ inputs }}

[doc("Build and activate the NixOS configuration")]
[linux]
switch:
    sudo nixos-rebuild switch --flake .#homestation@nixos

[doc("Build and activate the nix-darwin configuration")]
[macos]
switch:
    sudo darwin-rebuild switch --flake .#workstation@macos

[doc("Format sources")]
fmt:
    @just --fmt
    nix fmt

[arg("service", help="Service key to restore: github, gitlab, or all")]
[doc("Restore local SSH keys from Bitwarden; run bw login first")]
[positional-arguments]
ssh-restore service:
    bash scripts/ssh-restore.sh "$1"

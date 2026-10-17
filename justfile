set shell := ["bash", "-uc"]

[doc("List available recipes")]
default:
    @just --list

[doc("Update flake inputs")]
[arg("inputs", help="Input names to update; omit to update all inputs")]
update *inputs:
    nix flake update {{ inputs }}

[doc("Build and activate the NixOS configuration")]
switch:
    sudo nixos-rebuild switch --flake .#homestation@nixos

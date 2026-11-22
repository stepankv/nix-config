set shell := ["bash", "-uc"]

vps_ip := "193.33.153.176"

[doc("List available recipes")]
[group("local")]
default:
    @just --list

[arg("inputs", help="Input names to update; omit to update all inputs")]
[doc("Update flake inputs")]
[group("local")]
update *inputs:
    nix flake update {{ inputs }}

[doc("Build and activate the NixOS configuration")]
[group("local")]
[linux]
switch:
    sudo nixos-rebuild switch --flake .#homestation@nixos

[doc("Build and activate the nix-darwin configuration")]
[group("local")]
[macos]
switch:
    sudo darwin-rebuild switch --flake .#workstation@macos

[doc("Build the VPS deployment, installation and partitioning configurations locally")]
[group("vps")]
[linux]
check-vps:
    nix build --no-link --print-build-logs \
        '.#nixosConfigurations.vps.config.system.build.toplevel' \
        '.#nixosConfigurations.vps-install.config.system.build.toplevel' \
        '.#nixosConfigurations.vps-install.config.system.build.diskoScript'

[doc("Check the VPS configuration, then install NixOS, erasing /dev/vda")]
[group("vps")]
[linux]
install-vps: check-vps
    nix run '.#nixos-anywhere' -- \
        --flake '.#vps-install' \
        --build-on local \
        --target-host "root@{{ vps_ip }}"

[doc("Build NixOS locally and activate it on the VPS over SSH")]
[group("vps")]
[linux]
deploy-vps:
    nixos-rebuild switch \
        --flake '.#vps' \
        --target-host "root@{{ vps_ip }}"

[doc("Create a Zellij Web login token for developer; shown only once")]
[group("vps")]
vps-web-token:
    ssh "developer@{{ vps_ip }}" zellij web --create-token

[doc("Delete old profile generations on the VPS and run garbage collection")]
[group("vps")]
gc-vps:
    ssh -o BatchMode=yes \
        -o StrictHostKeyChecking=yes \
        "root@{{ vps_ip }}" nix-collect-garbage --delete-old

[doc("Format sources")]
[group("local")]
fmt:
    @just --fmt
    nix fmt

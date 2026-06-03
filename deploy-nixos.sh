#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash curl git cacert
#! nix-shell -I nixpkgs=https://github.com/nixos/nixpkgs/archive/a4bf06618f0b5ee50f14ed8f0da77d34ecc19160.tar.gz

set -ue

_flake_dir="${HOME}/workbench/nix-config"

mkdir -p "$_flake_dir" && cd "$_flake_dir" || exit 1
git clone https://github.com/stepankv/nix-config.git .
cp /etc/nixos/hardware-configuration.nix hosts/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake .#homestation@nixos

sudo mkdir -p /etc/brave/policies/managed
sudo ln -s "$XDG_CONFIG_HOME/brave-policies.json" /etc/brave/policies/managed/brave-policies.json

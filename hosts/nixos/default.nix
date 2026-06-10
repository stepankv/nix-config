{ lib, ... }:

{
  imports = [
    ./configuration.nix
    ./docker.nix
    ./gnome.nix
    ./hardware-configuration.nix
    ./nvidia.nix
    ./steam.nix
    ./xremap.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-kernel-modules"
      "steam"
      "steam-unwrapped"
    ];
}

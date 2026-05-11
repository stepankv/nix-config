{ ... }:

{
  imports = [
    ./configuration.nix
    ./docker.nix
    ./gnome.nix
    ./hardware-configuration.nix
    ./nvidia.nix
    ./xremap.nix
  ];
}

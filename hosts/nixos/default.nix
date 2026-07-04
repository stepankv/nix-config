{ ... }:

{
  imports = [
    ./configuration.nix
    ./docker.nix
    ./gnome.nix
    ./hardware-configuration.nix
    ./hiddify.nix
    ./nvidia.nix
    ./xremap.nix
  ];
}

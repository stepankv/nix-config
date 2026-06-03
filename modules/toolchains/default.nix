{ pkgs, ... }:

{
  imports = [
    ./java.nix
    ./rustup.nix
    ./python.nix
  ];

  home.packages = with pkgs.unstable; [
    nodejs
    gcc
  ];
}

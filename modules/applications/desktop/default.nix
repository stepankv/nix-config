{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./brave.nix
    ./hiddify.nix
    ./obsidian.nix
    ./telegram.nix
  ];

  home.packages = with pkgs.unstable; [
    deluge
    vlc
  ];
}

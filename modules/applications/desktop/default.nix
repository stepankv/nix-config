{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./brave.nix
    ./hiddify.nix
    ./jetbrains.nix
    ./obsidian.nix
    ./telegram.nix
  ];

  home.packages = with pkgs.unstable; [
    deluge
    vlc
  ];
}

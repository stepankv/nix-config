{ pkgs, ... }:

{
  imports = [
    ./alacritty.nix
    ./brave.nix
    ./obsidian.nix
    ./telegram.nix
  ];

  home.packages = with pkgs.unstable; [
    deluge
    vlc
  ];
}

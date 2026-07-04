{ pkgs, ... }:
{
  home.packages = with pkgs.unstable; [
    jetbrains.idea
  ];
}

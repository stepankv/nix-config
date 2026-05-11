{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    python3
    uv
  ];
}

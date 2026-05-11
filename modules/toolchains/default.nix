{ pkgs, ... }:

{
  imports = [
    ./rustup.nix
    ./python.nix
  ];

  home.packages = with pkgs.unstable; [
    nodejs
    gcc
    javaPackages.compiler.temurin-bin.jdk-25
  ];
}

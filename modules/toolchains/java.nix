{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    javaPackages.compiler.temurin-bin.jdk-25
    visualvm
    async-profiler
  ];
}

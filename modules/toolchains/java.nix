{ pkgs, ... }:

let
  jdk-25 = pkgs.unstable.javaPackages.compiler.temurin-bin.jdk-25;
  jdk-21 = pkgs.unstable.javaPackages.compiler.temurin-bin.jdk-21;
  jdk-17 = pkgs.unstable.javaPackages.compiler.temurin-bin.jdk-17;
in
{
  home.packages = with pkgs.unstable; [
    # Lower values take precedence when JDK files collide; JDK 25 is the default.
    (pkgs.lib.setPrio 10 jdk-25)
    (pkgs.lib.setPrio 20 jdk-21)
    (pkgs.lib.setPrio 30 jdk-17)
    visualvm
    async-profiler
  ];

  # Provide stable symlink paths for configuring JDKs in IDEs.
  home.file.".jdk/jdk-25".source = jdk-25.home;
  home.file.".jdk/jdk-21".source = jdk-21.home;
  home.file.".jdk/jdk-17".source = jdk-17.home;
}

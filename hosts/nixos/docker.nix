{ pkgs, ... }:

{
  # Start rootless docker to run the docker daemon as a non-root user
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}

{ pkgs, ... }:

{
  imports = [
    ../modules/applications/shell
  ];

  home = {
    username = "developer";
    homeDirectory = "/home/developer";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs.unstable; [
    gcc
    zip
    unzip
    codex
  ];
}

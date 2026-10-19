{ station, pkgs, ... }:

{
  imports = [
    ../modules/applications
    ../modules/gnome
    ../modules/toolchains
  ];

  home = {
    username = station.username;
    homeDirectory = "/home/${station.username}";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs.unstable; [
    xclip # used by Nvim to share OS and Nvim buffers (run `:h clipboard` for details)
    gcc # useed by tree-sitter to compile parsers
    zip
    unzip
    codex
  ];
}

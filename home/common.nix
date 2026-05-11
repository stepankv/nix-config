{ station, ... }:

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
}

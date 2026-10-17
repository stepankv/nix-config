{ station, ... }:

{
  home = {
    username = station.username;
    homeDirectory = "/Users/${station.username}";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;
}

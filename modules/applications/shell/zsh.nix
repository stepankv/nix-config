{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = false; # Completion freezing at startup session
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      extended = true;
      share = true;
    };
    # Disable switch to vi keybindings.
    # https://www.reddit.com/r/zsh/comments/p8ir7r/how_to_disable_vi_style_keybinds_in_zsh/
    defaultKeymap = "emacs";
    sessionVariables = config.home.sessionVariables;
  };
}

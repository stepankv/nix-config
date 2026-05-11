{ pkgs, dotfiles, ... }:

{
  home.packages = with pkgs.unstable; [
    lazygit
  ];

  xdg.configFile."lazygit".source = "${dotfiles}/lazygit";

  programs.zsh = {
    initContent = ''
      export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/themes/island_dark.yml"
    '';
    shellAliases = {
      gi = "lazygit";
    };
  };
}

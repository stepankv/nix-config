{ pkgs, dotfiles, ... }:
{
  home.packages = with pkgs.unstable; [
    fzf
    fd # better file
    ripgrep # bette grep
    bat # better cat (for file preview)
  ];

  xdg.configFile."fzf".source = "${dotfiles}/fzf";
  xdg.configFile.".ripgreprc".source = "${dotfiles}/.ripgreprc";

  programs.zsh = {
    initContent = ''
      export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/.ripgreprc";
      source "$XDG_CONFIG_HOME/fzf/defaults.sh"
      source "$XDG_CONFIG_HOME/fzf/theme.sh"
      source "$XDG_CONFIG_HOME/fzf/functions.sh"
      source <(fzf --zsh)
    '';
  };
}

{ pkgs, dotfiles, ... }:

{
  home.packages = with pkgs.unstable; [
    yazi
  ];

  xdg.configFile."yazi".source = "${dotfiles}/yazi";

  programs.zsh.initContent = ''
    source "$XDG_CONFIG_HOME/yazi/wrapper.sh"
  '';
}

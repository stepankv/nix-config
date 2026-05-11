{ pkgs, dotfiles, ... }:

{
  home.packages = with pkgs.unstable; [
    zellij
  ];

  xdg.configFile."zellij".source = "${dotfiles}/zellij";

  programs.zsh.shellAliases = {
    zj = "zellij";
  };
}

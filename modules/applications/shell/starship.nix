{ pkgs, dotfiles, ... }:

{
  home.packages = with pkgs.unstable; [
    starship
  ];

  xdg.configFile."starship.toml".source = "${dotfiles}/starship.toml";

  programs.zsh.initContent = ''
    eval "$(starship init zsh)"
  '';
}

{ pkgs, dotfiles, ... }:

{
  home.packages = with pkgs.unstable; [
    git
  ];

  xdg.configFile."git".source = "${dotfiles}/git";
}

{ pkgs, dotfiles, ... }:
{

  # Home Manager rebuilds the theme cache after linking configuration files.
  programs.bat = {
    enable = true;
    package = pkgs.unstable.bat;
  };

  xdg.configFile."bat/config".source = "${dotfiles}/bat/config";
  xdg.configFile."bat/syntaxes".source = "${dotfiles}/sublime/syntaxes";
  xdg.configFile."bat/themes/island-dark.tmTheme".source = "${dotfiles}/sublime/themes/island-dark.tmTheme";
}

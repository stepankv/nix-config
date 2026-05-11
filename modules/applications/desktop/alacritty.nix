{
  pkgs,
  lib,
  dotfiles,
  ...
}:
let
  baseConfig = builtins.fromTOML (builtins.readFile "${dotfiles}/alacritty/alacritty.toml");

  alacittyConf =
    if pkgs.stdenv.isLinux then
      lib.recursiveUpdate baseConfig {
        # Hide title bar. "Buttonless" available only on macOS.
        window.decorations = "None";
        # Alacritty on Linux distros, show different (bigger) font size.
        # To ensure a consistent appearance across different systems, DEs,
        # and compositors, font substitution seems to be the easiest way to fix it.
        font.size = 11;
      }
    else
      baseConfig;

  tomlFormat = pkgs.formats.toml { };
in
{
  home.packages = with pkgs.unstable; [
    alacritty
    nerd-fonts.jetbrains-mono
  ];

  xdg.configFile."alacritty/alacritty.toml".source =
    tomlFormat.generate "alacritty.toml" alacittyConf;
  xdg.configFile."alacritty/island_dark.toml".source = "${dotfiles}/alacritty/island_dark.toml";
  xdg.configFile."alacritty/keybindings.toml".source = "${dotfiles}/alacritty/keybindings.toml";
}

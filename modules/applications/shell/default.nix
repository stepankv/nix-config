{ ... }:

{
  imports = [
    ./ai.nix
    ./fzf.nix # fuzzy search
    ./git.nix # git tui
    ./nvim.nix
    ./starship.nix # shell prompt
    ./utils.nix
    ./yazi.nix # file manager
    ./zellij.nix # terminal splitter
    ./zsh.nix
  ];
}

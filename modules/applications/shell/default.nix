{ pkgs, ... }:

{
  imports = [
    ./fzf.nix # fuzzy search
    ./git.nix
    ./lazygit.nix # git tui
    ./nvim.nix
    ./starship.nix # shell prompt
    ./yazi.nix # file manager
    ./zellij.nix # terminal splitter
    ./zsh.nix
  ];

  home.packages = with pkgs.unstable; [
    curl
    wget
    file
    zip
    unzip
    eza # better ls
    delta # syntax-highlighting pager for diff (e.g git)
    btop # better htop
    cloc # print project file summary
    lazydocker # docker tui
    just # command runner
  ];

  programs.zsh.shellAliases = {
    ls = "eza --color=always --long --icons=always --no-user --no-time --no-permissions";
    lzd = "lazydocker";
    jt = "just";
  };
}

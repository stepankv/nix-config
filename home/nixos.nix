{ pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs.unstable; [
    steam
  ];

  programs.zsh.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake .#homestation@nixos";
  };
}

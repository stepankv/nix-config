{ ... }:

{
  imports = [
    ./common.nix
  ];

  programs.zsh.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake .#homestation@nixos";
  };
}

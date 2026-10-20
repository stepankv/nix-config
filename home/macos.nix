{ workstation, dotfiles, pkgs, ... }:

{
  imports = [
    ../modules/applications/shell
    ../modules/applications/desktop/alacritty.nix
    ../modules/toolchains
  ];

  home = {
    username = workstation.username;
    homeDirectory = "/Users/${workstation.username}";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  xdg.enable = true;
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  home.file.".nessy/NESSY.md".source = "${dotfiles}/ai/AGENTS.md";

  home.packages = with pkgs.unstable; [
    kubectl
    kubernetes-helm
    k9s
    docker
    docker-compose
    k6
    grpcurl
    s3cmd
    toxiproxy
    wasmtime
    wasmedge
  ];
}

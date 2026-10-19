{ workstation, pkgs, ... }:

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
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

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

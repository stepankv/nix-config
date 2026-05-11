{ pkgs, ... }:

{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    adwaita-fonts
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.dash-to-dock
    gnomeExtensions.xremap
  ];

  dconf = {
    enable = true;
    settings = {
      # Disable default ubuntu extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        disabled-extensions = [
          "ubuntu-dock@ubuntu.com"
          "ding@rastersoft.com"
        ];
      };
    };
  };

  targets.genericLinux.enable = true;

  # Provide access to GPU for desktop applications.
  # https://nix-community.github.io/home-manager/#sec-usage-gpu-sudo
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    # Must match with host driver version.
    version = "595.58.03";
    sha256 = "sha256-jA1Plnt5MsSrVxQnKu6BAzkrCnAskq+lVRdtNiBYKfk=";
  };

  programs.zsh.shellAliases = {
    switch = "home-manager switch --flake .#homestation@ubuntu --extra-experimental-features nix-command --extra-experimental-features flakes";
  };
}

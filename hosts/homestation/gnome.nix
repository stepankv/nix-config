{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [
      xterm
    ];
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Exclude default gnome applications
  services.gnome.core-apps.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    firefox
    gnome-tour
  ];

  environment.systemPackages = with pkgs; [
    gnome-text-editor
    gnome-logs
    gnome-disk-utility
    gnome-terminal
    nautilus
    baobab # disk usage analyzer
    papers # pdf reader
    loupe # image viewer

    yaru-theme # Gnome theme
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    gnomeExtensions.xremap
  ];
}

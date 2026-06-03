{ pkgs, station, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = station.hostname;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Moscow";
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8"; # Start weekend from monday.
    };
  };

  security.rtkit.enable = true;

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  users.users.${station.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Perform garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot.configurationLimit = 15; # Limit generations

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}

{ workstation, ... }:

{
  imports = [
    ./homebrew.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.${workstation.username}.home = "/Users/${workstation.username}";
  system.primaryUser = workstation.username;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    interval = [
      {
        Weekday = 7;
        Hour = 12;
        Minute = 0;
      }
    ];
    options = "";
  };

  system.stateVersion = 6;
}

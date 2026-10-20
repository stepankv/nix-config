{
  config,
  workstation,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  ...
}:

{
  imports = [
    nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = workstation.username;
    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
    };
    mutableTaps = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    casks = [
      "another-redis-desktop-manager"
      "orbstack"
      "vlc"
    ];

    onActivation = {
      # Do not run brew update: Homebrew and tap revisions are pinned by flake.lock.
      autoUpdate = false;
      # Upgrade installed formulae and casks during activation using the pinned taps.
      upgrade = true;
      cleanup = "zap";
    };
  };
}

{
  description = "Workstations setup";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dotfiles = {
      url = "github:stepankv/dotfiles";
      flake = false;
    };

    dotfiles-nvim = {
      url = "github:stepankv/dotfiles.nvim";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs-stable,
      nixpkgs-unstable,
      xremap-flake,
      home-manager,
      dotfiles,
      dotfiles-nvim,
      ...
    }:
    let
      # User-facing applications (shell tools & desktop apps)
      # use the unstable channel to get the latest versions
      # without waiting for the next NixOS release cycle.
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs-unstable.lib.getName pkg) [
            "obsidian"
          ];
      };

      unstable-overlay = final: prev: {
        unstable = pkgs-unstable;
      };

      ubuntu-packages = import nixpkgs-stable {
        system = "x86_64-linux";
        config.nvidia.acceptLicense = true;
        config.allowUnfreePredicate =
          pkg:
          builtins.elem (nixpkgs-unstable.lib.getName pkg) [
            "nvidia-x11"
          ];
        overlays = [ unstable-overlay ];
      };

      station = {
        username = "stepan";
        hostname = "kfcnix-734";
      };
    in
    {
      nixosConfigurations = {
        "homestation@nixos" = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit station;
          };
          modules = [
            ./hosts/nixos
            xremap-flake.nixosModules.default
            home-manager.nixosModules.home-manager
            { nixpkgs.overlays = [ unstable-overlay ]; }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${station.username} = import ./home/nixos.nix;
                extraSpecialArgs = { inherit dotfiles dotfiles-nvim station; };
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "homestation@ubuntu" = home-manager.lib.homeManagerConfiguration {
          pkgs = ubuntu-packages;
          modules = [ ./home/ubuntu.nix ];
          extraSpecialArgs = { inherit dotfiles dotfiles-nvim station; };
        };
      };
    };
}

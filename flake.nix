{
  description = "Workstations setup";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
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
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      dotfiles,
      dotfiles-nvim,
      ...
    }:
    let
      # User-facing applications (shell tools & desktop apps)
      # use the unstable channel to get the latest versions
      # without waiting for the next NixOS release cycle.
      unstable-overlay = final: prev: {
        unstable = import nixpkgs-unstable {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs-unstable.lib.getName pkg) [
              "obsidian"
            ];
        };
      };

      homestation = {
        username = "stepan";
        hostname = "kfcnix-734";
      };
      workstation = {
        username = "s.kruglov";
      };
    in
    {
      formatter.x86_64-linux = nixpkgs-stable.legacyPackages.x86_64-linux.nixfmt-tree;
      formatter.aarch64-darwin = nixpkgs-stable.legacyPackages.aarch64-darwin.nixfmt-tree;

      nixosConfigurations = {
        "homestation@nixos" = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            station = homestation;
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
                users.${homestation.username} = import ./home/nixos.nix;
                extraSpecialArgs = {
                  inherit dotfiles dotfiles-nvim;
                  station = homestation;
                };
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        "workstation@macos" = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit workstation nix-homebrew homebrew-core homebrew-cask; };
          modules = [
            ./hosts/macos
            home-manager.darwinModules.home-manager
            { nixpkgs.overlays = [ unstable-overlay ]; }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${workstation.username} = import ./home/macos.nix;
                extraSpecialArgs = { inherit dotfiles dotfiles-nvim workstation; };
              };
            }
          ];
        };
      };
    };
}

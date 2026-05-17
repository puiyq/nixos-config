{
  description = "Kasumi's NixOS flake";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/x86_64-linux";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
      flake = false;
    };

    # System modules
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Desktop / WM
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
        niri-unstable.follows = "";
        niri-stable.follows = "";
        xwayland-satellite-unstable.follows = "";
        xwayland-satellite-stable.follows = "";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs = {
        nixpkgs.follows = "";
        noctalia-qs.follows = "";
      };
    };
    noctalia-v5 = {
      url = "github:noctalia-dev/noctalia-shell/v5";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Apps / tooling
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-compat.follows = "flake-compat";
    };
    nixvirt = {
      url = "github:AshleyYakeley/NixVirt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        ndg.follows = "";
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    run0-sudo-shim = {
      url = "github:lordgrimmauld/run0-sudo-shim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        nix-github-actions.follows = "";
      };
    };
    selector4nix = {
      url = "github:StarryReverie/selector4nix/master";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        systems = import inputs.systems;

        debug = true;
        imports = [
          # keep-sorted start
          ./flake-modules/devshells.nix
          ./flake-modules/overlays.nix
          ./flake-modules/packages.nix
          ./flake-modules/readOnlyPkgs.nix
          ./flake-modules/treefmt.nix
          # keep-sorted end
        ];

        flake.nixosConfigurations.popipa = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            host = "popipa";
            username = "kasumi";
          };
          modules = [
            ./hosts/popipa
            inputs.nixpkgs.nixosModules.readOnlyPkgs
            (
              { config, ... }:
              {
                nixpkgs.pkgs = withSystem config.hardware.facter.report.system ({ pkgs, ... }: pkgs);
              }
            )
          ];
        };
      }
    );
}

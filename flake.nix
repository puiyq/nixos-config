{
  description = "ZaneyOS";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    determinate = {
      url = "github:DeterminateSystems/nix-src";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        git-hooks-nix.follows = "";
      };
    };

    # System configuration
    systems.url = "github:nix-systems/x86_64-linux";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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

    # Development tools - Editors and LSP
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "";
        ndg.follows = "";
      };
    };

    # Development tools - Language toolchains
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Utilities
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/nixos-config";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      templates.treefmt = {
        path = ./templates/treefmt;
        description = "Minimal treefmt-nix";
      };
      formatter.${pkgs.stdenv.hostPlatform.system} = treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              username
              host
              flake_dir
              ;
            profile = "amd";
          };
          modules = [
            ./profiles/amd
          ];
        };
      };
    };
}

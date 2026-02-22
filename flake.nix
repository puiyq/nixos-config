{
  description = "ZaneyOS";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Lix
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        lix.follows = "lix";
        flake-utils.inputs.systems.follows = "systems";
      };
    };
    flake-compat = {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/main.tar.gz";
      flake = false;
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
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
        niri-stable.follows = "";
        xwayland-satellite-stable.follows = "";
      };
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Applications
    nixvirt = {
      url = "github:AshleyYakeley/NixVirt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    nix-matlab = {
      url = "github:puiyq/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
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
    inputs:

    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        ./flake-modules/treefmt.nix
        ./flake-modules/packages.nix
        ./flake-modules/overlays.nix
        ./flake-modules/devshells.nix
      ];

      flake =
        let
          host = "popipa";
          username = "kasumi";
        in
        {
          nixosConfigurations = {
            popipa = inputs.nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = {
                inherit
                  inputs
                  host
                  username
                  ;
              };
              modules = [
                ./hosts/popipa

                {
                  nixpkgs.overlays = [
                    inputs.self.overlays.default
                    inputs.niri.overlays.niri
                    inputs.nix-matlab.overlays.default
                  ];
                }
              ];
            };
          };
        };
    };
}

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

    # Placeholders
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
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
    chaotic.url = "github:puiyq/nyx-puiyq";
    chaotic.inputs = {
      nixpkgs.follows = "nixpkgs";
      rust-overlay.follows = "rust-overlay";
    };

    stylix = {
      url = "github:nix-community/stylix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
        # nur.follows = "nur";
      };
    };

    # Window manager and related
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "";
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
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        vicinae.follows = "vicinae";
      };
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
        darwin.follows = "";
      };
    };
    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
        agenix.follows = "agenix";
      };
    };
    mysecrets = {
      url = "git+ssh://git@github.com/puiyq/nix-secret.git?shallow=1";
      flake = false;
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
    # Alternative package managers
    #lix = {
    #  url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    #  flake = false;
    #};
    #lix-module = {
    # url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    # inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #   lix.follows = "lix";
    # };
    #};

    #nur = {
    # url = "github:nix-community/NUR";
    # inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-parts.follows = "flake-parts";
    #};
  };
  outputs =
    {
      nixpkgs,
      treefmt-nix,
      rust-overlay,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/nixos-config";
      pkgs = nixpkgs.legacyPackages.${system}.extend (
        final: prev:
        (nixpkgs.lib.composeManyExtensions [
          rust-overlay.overlays.default
        ] final prev)
      );
    in
    {
      templates.treefmt = {
        path = ./templates/treefmt;
        description = "Minimal treefmt-nix";
      };
      formatter.${pkgs.stdenv.hostPlatform.system} = treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix;
      checks.${pkgs.stdenv.hostPlatform.system} = {
        animeko = pkgs.callPackage pkgs/animeko { };
      };
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
      devShells.${pkgs.stdenv.hostPlatform.system} = {
        ts = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bun ];
        };
        fortran = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gfortran
          ];
        };
        zig = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            zig
          ];
        };
        go = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            go
          ];
          shellHook = ''
            export CC=clang
            export CXX=clang++
            export CGO_CFLAGS="-O2 -march=znver4 -g"
            export CGO_CXXFLAGS="-O2 -march=znver4 -g"
            export GOAMD64=v4
          '';
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          buildInputs = with pkgs; [
            (rustlings.overrideAttrs {
              extraRustcOpts = "-C target-cpu=znver4 -C lto -C link-arg=-fuse-ld=lld -C codegen-units=1 -C target-feature=+avx512f,+avx512dq,+avx512cd,+avx512bw,+avx512vl";
              postFixup = '''';
            })
          ];
          nativeBuildInputs = [
            pkgs.rust-bin.stable.latest.default
            #.override {
            #  extensions = [
            #   "llvm-tools"
            #   "rust-src"
            # ];
            #}
          ];
        };
      };
    };
}

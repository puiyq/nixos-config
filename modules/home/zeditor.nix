{
  pkgs,
  lib,
  host,
  ...
}:
let

  self = "(builtins.getFlake \"/home/${host}/nixos-config\")";
  system = "${self}.nixosConfigurations.nixos";
  home = "${system}.options.home-manager.users.type";
  settings = {
    formatting.command = lib.getExe pkgs.nixfmt;
    nixpkgs.expr = "${system}._module.args.pkgs";
    options = {
      nixos.expr = "${system}.options";
      home-manager.expr = "${home}.getSubOptions []";
    };
  };
in
{
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      clang-tools
      rust-analyzer
      package-version-server
    ];
    extensions = [
      "nix"
      "dracula-flat"
      "catppuccin-icons"
    ];

    mutableUserSettings = false;
    userSettings = {
      base_keymap = "VSCode";
      theme = lib.mkForce "Dracula Blur";
      icon_theme = "Catppuccin Mocha";
      inlay_hints = {
        enabled = true;
        show_background = true;
      };

      edit_predictions = {
        disabled_globs = [ "**/*.age" ];
      };

      /*
        context_servers = {
        nixos = {
          command = "${lib.getExe pkgs.nixVersions.git}";
          args = [
            "run"
            "github:felixdorn/mcp-nix"
            "--"
            "--homemanager"
            "--noogle"
            "--include=read_derivation,read_nixos_module,read_home_module"
            "--exclude=list_nixos_channels,list_homemanager_releases"
          ];
        };
        };
      */

      lsp = {
        clangd = {
          binary.path = lib.getExe' pkgs.clang-tools "clangd";
        };
        nixd = { inherit settings; };
        package-version-server = {
          binary.path = lib.getExe pkgs.package-version-server;
        };
        ruff = {
          binary = {
            path = lib.getExe pkgs.ruff;
            arguments = [ "server" ];
          };
          initialization_options.settings = {
            "lineLength" = 80;
            lint.extendSelect = [ "I" ];
          };
        };
        rust-analyzer = {
          enable_lsp_tasks = true;
          binary.path = lib.getExe pkgs.rust-analyzer;
          initialization_options = {
            cargo.all_Features = true;
            check.command = "clippy";
            procMacro.enable = true;
          };
        };
        ty = {
          binary = {
            path = lib.getExe pkgs.ty;
            arguments = [ "server" ];
          };
          settings = {
            diagnosticMode = "off";
          };
        };
      };

      languages = {
        "C++" = {
          format_on_save = "on";
        };
        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
        Python = {
          code_actions_on_format = {
            "source.organizeImports.ruff" = true;
            "source.fixAll.ruff" = true;
          };
          language_servers = [
            "ruff"
            "ty"
            "!basedpyright"
          ];
        };
        Rust = {
          language_servers = [ "rust-analyzer" ];
        };
      };

      vim_mode = true;
      journal.hour_format = "hour24";
      auto_update = false;

      buffer_line_height = "comfortable";

      load_direnv = "direct";

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };
    };
  };
}

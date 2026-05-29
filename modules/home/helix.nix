{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.helix = {
    enable = true;
    package = pkgs.helix_git;
    defaultEditor = true;

    extraPackages = with pkgs; [
      bash-language-server
      shellcheck
      shfmt
      nixd
      nixfmt-rs
      yaml-language-server
    ];

    settings = {
      theme = lib.mkForce "dracula";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        soft-wrap.enable = false;
        auto-format = true;
        completion-replace = true;
        indent-guides.render = true;
        bufferline = "multiple";
        trim-trailing-whitespace = true;
        clipboard-provider = "wayland";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
        gutters = [
          "diagnostics"
          "line-numbers"
          "spacer"
          "diff"
        ];
      };
    };

    languages = {
      language-server = {
        nixd = {
          command = lib.getExe pkgs.nixd;
          config =
            let
              self = "(builtins.getFlake \"${config.home.homeDirectory}/nixos-config\")";
              system = "${self}.nixosConfigurations.nixos";
              home = "${system}.options.home-manager.users.type";
            in
            {
              nixd = {
                formatting.command = [ (lib.getExe pkgs.nixfmt-rs) ];
                nixpkgs.expr = "${system}._module.args.pkgs";
                options = {
                  nixos.expr = "${system}.options";
                  home-manager.expr = "${home}.getSubOptions []";
                  flake-parts.expr = "${self}.debug.options";
                  flake-parts2.expr = "${self}.currentSystem.options";
                };
              };
            };
        };

        bash-language-server = {
          command = lib.getExe pkgs.bash-language-server;
          args = [ "start" ];
          config = {
            bashIde = {
              shellcheckPath = lib.getExe pkgs.shellcheck;
              enableShellCheckOnOpen = true;
              enableShellCheckOnSave = true;
            };
          };
        };

        yaml-language-server = {
          command = lib.getExe pkgs.yaml-language-server;
          args = [ "--stdio" ];
          config.yaml = {
            format.enable = true;
            validate = true;
            completion = true;
          };
        };
      };

      language = [
        {
          name = "nix";
          language-servers = [ "nixd" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.nixfmt-rs;
          };
        }
        {
          name = "bash";
          language-servers = [ "bash-language-server" ];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.shfmt;
            args = [
              "-i"
              "2"
            ];
          };
        }
        {
          name = "yaml";
          language-servers = [ "yaml-language-server" ];
          auto-format = true;
        }
      ];
    };
  };
}

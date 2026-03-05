{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.nvf = {
    enable = true;

    settings.vim = {
      lsp.enable = true;
      withRuby = false;
      enableLuaLoader = true;
      diagnostics.enable = true;
      options = {
        tabstop = 4;
        shiftwidth = 2;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      keymaps = [
        {
          key = "jk";
          mode = [ "i" ];
          action = "<ESC>";
          desc = "Exit insert mode";
        }
        {
          key = "<leader>nh";
          mode = [ "n" ];
          action = ":nohl<CR>";
          desc = "Clear search highlights";
        }
        {
          key = "<leader>ff";
          mode = [ "n" ];
          action = "<cmd>Telescope find_files<cr>";
          desc = "Search files by name";
        }
        {
          key = "<leader>lg";
          mode = [ "n" ];
          action = "<cmd>Telescope live_grep<cr>";
          desc = "Search files by contents";
        }
        {
          key = "<leader>e";
          mode = [ "n" ];
          action = "<cmd>Neotree toggle<cr>";
          desc = "File browser toggle";
        }
        {
          key = "<C-h>";
          mode = [ "i" ];
          action = "<Left>";
          desc = "Move left in insert mode";
        }
        {
          key = "<C-j>";
          mode = [ "i" ];
          action = "<Down>";
          desc = "Move down in insert mode";
        }
        {
          key = "<C-k>";
          mode = [ "i" ];
          action = "<Up>";
          desc = "Move up in insert mode";
        }
        {
          key = "<C-l>";
          mode = [ "i" ];
          action = "<Right>";
          desc = "Move right in insert mode";
        }
        {
          key = "<leader>dj";
          mode = [ "n" ];
          action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
          desc = "Go to next diagnostic";
        }
        {
          key = "<leader>dk";
          mode = [ "n" ];
          action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
          desc = "Go to previous diagnostic";
        }
        {
          key = "<leader>dl";
          mode = [ "n" ];
          action = "<cmd>Lspsaga show_line_diagnostics<CR>";
          desc = "Show diagnostic details";
        }
        {
          key = "<leader>dt";
          mode = [ "n" ];
          action = "<cmd>Trouble diagnostics toggle<cr>";
          desc = "Toggle diagnostics list";
        }
      ];

      lsp = {
        inlayHints.enable = true;
        formatOnSave = true;
        trouble.enable = true;
        lspSignature.enable = true;
        servers = {
          nixd = {
            cmd = [ (lib.getExe pkgs.nixd) ];
            filetypes = [ "nix" ];
            root_markers = [
              ".git"
              "flake.nix"
            ];
            settings = {
              nixd =
                let
                  self = "(builtins.getFlake \"${config.home.homeDirectory}/nixos-config\")";
                  system = "${self}.nixosConfigurations.nixos";
                  home = "${system}.options.home-manager.users.type";
                in
                {
                  formatting.command = lib.getExe pkgs.nixfmt;
                  nixpkgs.expr = "${system}._module.args.pkgs";
                  options = {
                    nixos.expr = "${system}.options";
                    home-manager.expr = "${home}.getSubOptions []";
                  };
                };
            };
          };
        };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        bash = {
          enable = true;
          lsp.enable = true;
        };
        nix = {
          enable = true;
          format.enable = false;
          lsp.enable = false;
        };
        r = {
          enable = true;
          format.type = [ "styler" ];
        };
        yaml = {
          enable = true;
          lsp.enable = true;
        };
      };
      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        rainbow-delimiters.enable = true;
        indent-blankline.enable = true;
      };

      statusline.lualine.enable = true;
      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;
      tabline.nvimBufferline.enable = true;
      filetree.neo-tree.enable = true;
      notify.nvim-notify.enable = true;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      utility = {
        preview.glow.enable = true;
        motion.leap.enable = true;
      };
      ui = {
        borders.enable = true;
        noice = {
          enable = true;
          setupOpts.lsp.signature.enabled = true;
        };
        colorizer.enable = true;
        illuminate.enable = true;
        smartcolumn.enable = true;
        fastaction.enable = true;
      };
    };
  };
}

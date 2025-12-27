{
  config,
  pkgs,
  flake_dir,
  host,
  lib,
  ...
}:
{
  programs.nvf = {
    enable = true;

    settings.vim = {
      theme = {
        enable = true;
        name = "dracula";
      };
      lsp.enable = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      withRuby = false;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
      options = {
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      maps = {
        normal = {
          "<leader>e" = {
            action = "<CMD>Neotree toggle<CR>";
            silent = false;
          };
        };
      };
      debugger.nvim-dap.ui.enable = false;
      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
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
          key = "<leader>fe";
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

      telescope.enable = true;

      lsp = {
        inlayHints.enable = true;
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false; # view lsp doc like in vscode
        servers = {
          #leanls = {
          #  cmd = [
          #   (lib.getExe pkgs.lean4)
          #   "--server"
          # ];
          # filetypes = [ "lean" ];
          # root_markers = [
          #   "lakefile.lean"
          #   "lean-toolchain"
          #   ".git"
          # ];
          #};
          ruff = {
            cmd = [
              (lib.getExe pkgs.ruff)
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "setup.py"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
              ".git"
            ];
            on_attach = {
              _type = "lua-inline";
              expr = "
                function(client, bufnr)
                  client.server_capabilities.hoverProvider = false
                  client.server_capabilities.definitionProvider = false
                  client.server_capabilities.referencesProvider = false
                  client.server_capabilities.renameProvider = false
                end";
            };
          };
          ty = {
            cmd = [
              (lib.getExe pkgs.ty)
              "server"
            ];
            filetypes = [ "python" ];
            root_markers = [
              "pyproject.toml"
              "setup.py"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
              ".git"
            ];
          };
          nixd = {
            cmd = [ (lib.getExe pkgs.nixd) ];
            filetypes = [ "nix" ];
            settings = {
              nixd = {
                formatting.command = lib.getExe pkgs.nixfmt;
                nixpkgs.expr = "(builtins.getFlake (builtins.toString ${flake_dir})).nixosConfigurations.${host}.pkgs";
                options = {
                  nixos = {
                    expr = "(builtins.getFlake (builtins.toString ${flake_dir})).nixosConfigurations.${host}.options";
                  };
                  home_manager = {
                    expr = "(builtins.getFlake (builtins.toString ${flake_dir})).nixosConfigurations.${host}.options.home-manager.users.type.getSubOptions []";
                  };
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
        csharp = {
          enable = false;
          lsp.enable = true;
          lsp.servers = [ "omnisharp" ];
        };
        haskell = {
          enable = false;
          lsp.enable = false;
        };
        bash = {
          enable = true;
          lsp.enable = true;
        };
        nim = {
          enable = false;
          lsp.enable = true;
        };
        nix = {
          enable = true;
          format.enable = false;
          lsp.enable = false;
        };
        clang = {
          enable = true;
          cHeader = true;
          lsp.enable = true;
          dap.enable = false;
        };
        zig.enable = false;
        go = {
          enable = false;
          lsp.enable = true;
        };
        python = {
          enable = true;
          lsp.enable = false;
          format.type = [ "ruff" ];
        };
        ts = {
          enable = false;
          lsp.enable = true;
          format.type = [ "biome" ];
          extensions.ts-error-translator.enable = true;
        };
        html.enable = true;
        css = {
          enable = true;
          lsp.enable = true;
          format.type = [ "biome" ];
        };
        rust = {
          enable = false;
          lsp = {
            enable = true;
            package = pkgs.rust-bin.stable.latest.default.override {
              extensions = [
                "rust-analyzer"
                "rust-src"
              ];
            };
            opts = ''
              ['rust-analyzer'] = {
                cargo = {allFeature = true},
                checkOnSave = true,
                check = {
                  enable = true,
                  command = 'clippy',
                  features = 'all',
                },
                procMacro = {
                  enable = true,
                },
              },
            '';
          };
        };
        #markdown.enable = true;
        #lua.enable = true;
        #typst.enable = true;
      };
      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        rainbow-delimiters.enable = true;
        indent-blankline = {
          enable = true;
        };
      };

      statusline.lualine.enable = true;
      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;
      tabline.nvimBufferline.enable = true;
      treesitter.context.enable = false;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      git = {
        enable = false;
        gitsigns.enable = false;
        gitsigns.codeActions.enable = false;
      };
      projects.project-nvim.enable = true;
      dashboard.dashboard-nvim.enable = false;
      filetree.neo-tree.enable = true;
      notify.nvim-notify = {
        enable = true;
        setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };
      utility = {
        yazi-nvim.enable = true;
        preview.glow.enable = true;
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        diffview-nvim.enable = true;
        images.image-nvim.enable = false;
        motion = {
          leap.enable = true;
          precognition.enable = false;
        };
      };
      ui = {
        borders.enable = true;
        noice = {
          enable = true;
          setupOpts.lsp.signature.enabled = true;
        };
        colorizer.enable = true;
        illuminate.enable = true;
        breadcrumbs = {
          enable = false;
          navbuddy.enable = false;
        };
        smartcolumn.enable = true;
        fastaction.enable = true;
      };
      session.nvim-session-manager.enable = false;
      comments.comment-nvim.enable = true;
    };
  };
}

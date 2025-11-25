{
  config,
  pkgs,
  flake_dir,
  inputs,
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
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;
      options = {
        fillchars = "eob: "; # no ~ after EOF
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };

      maps = {
        normal = {
          "<leader>e" = {
            action = "<CMD>Neotree toggle<CR>";
            silent = false;
          };
        };
      };
      debugger.nvim-dap.ui.enable = true;
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
          zls.cmd = lib.mkForce [ (lib.getExe inputs.zls.packages.${pkgs.stdenv.hostPlatform.system}.zls) ];
          nil = lib.mkForce { };
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
                  -- Disable hover in favor of basedpyright
                  client.server_capabilities.hoverProvider = false
                end";
            };
          };
          basedpyright.settings.basedpyright = {
            disableOrganizeImports = true;
            ignore = [ "*" ];

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

      formatter.conform-nvim.setupOpts.formatters = {
        alejandra = lib.mkForce { };
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        haskell = {
          enable = true;
          lsp.enable = false;
        };
        bash = {
          enable = true;
          lsp.enable = true;
        };
        nix.enable = true;
        clang = {
          enable = true;
          cHeader = true;
          lsp.enable = true;
          dap.enable = true;
        };
        zig.enable = true;
        go = {
          enable = true;
          lsp.enable = true;
        };
        python = {
          enable = true;
          lsp.enable = true;
          format.type = [ "ruff" ];
        };
        ts = {
          enable = true;
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
          enable = true;
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
        indent-blankline = {
          enable = true;
          setupOpts = {
            exclude = {
              filetypes = [ "dashboard" ];
            };
          };
        };
        rainbow-delimiters.enable = true;
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
      notify = {
        nvim-notify.enable = true;
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };
      utility = {
        yazi-nvim.enable = true;
        preview.glow.enable = true;
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = false;
        };
        images.image-nvim.enable = false;
      };
      ui = {
        borders.enable = true;
        noice.enable = true;
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

  # Source custom Lua explicitly
  home.file.".config/nvim/init.lua" = {
    text = ''
      vim.notify("Main init.lua loaded", vim.log.levels.INFO)
      pcall(require, "custom.init")
    '';
  };

  home.file.".config/nvim/lua/custom/init.lua" = {
    text = ''
      -- Debug notification
      vim.notify("Custom Lua loaded", vim.log.levels.INFO)
      -- Diagnostics configuration (fallback)
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          prefix = "●"
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true
      })
    '';
  };
}

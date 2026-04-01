{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  home.shellAliases = {
    ls = "eza";
    lt = "eza --tree --level=2";
    ll = "eza  -lh --no-user --long";
    la = "eza -lah ";
    tree = "eza --tree ";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        theme = lib.mkForce "Dracula";
      };
      extraPackages = with pkgs.bat-extras; [ batman ];
    };

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
        rounded_corners = true;
        proc_tree = true;
        show_gpu_info = "on";
        show_uptime = true;
        show_coretemp = true;
        cpu_sensor = "auto";
        show_disks = true;
        only_physical = true;
        io_mode = true;
        io_graph_combined = false;
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      icons = "auto";
      git = true;
      extraOptions = [
        "--group-directories-first"
        "--no-quotes"
        "--header"
        "--git-ignore"
        "--icons=always"
        "--classify"
        "--hyperlink"
      ];
    };

    nix-index = {
      enable = true;
    };

    nix-index-database.comma = {
      enable = true;
    };

    numbat = {
      enable = true;
      settings = {
        exchange-rates = {
          fetching-policy = "on-first-use";
        };
        intro-banner = "short";
        prompt = ">>>";
      };
    };

    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
        };
      };
    };

    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}

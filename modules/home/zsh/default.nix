{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.shell.enableZshIntegration = true;
  programs = {
    carapace.enable = true;
    atuin = {
      enable = true;
      flags = [ "--disable-ctrl-r" ];
      settings = {
        style = "auto";
        command_chaining = true;
        enter_accept = true;
        prefers_reduced_motion = true;
        sync.records = true;
      };
    };
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
          "root"
          "line"
        ];
      };
      historySubstringSearch.enable = true;

      history = {
        ignoreDups = true;
        save = 10000;
        size = 10000;
      };

      oh-my-zsh = {
        enable = true;
      };

      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];

      initContent = ''
        nix() {
                case "$1" in
                shell | develop | build)
                        nom "$@"
                        ;;
                *)
                        command nix "$@"
                        ;;
                esac
        }
      '';

      shellAliases = {
        sv = "sudoedit";
        v = "nvim";
        c = "clear";
        f = "c && fastfetch";
        fr = "nh os switch";
        ncg = "nh clean all";
        man = "batman";
        curl = "curlie";
        cat = "bat";
        nix-shell = "nom-shell";
        nix-build = "nom-build";
      };
    };
  };
}

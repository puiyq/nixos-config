{
  pkgs,
  lib,
  config,
  shellDefault,
  ...
}:
{
  config = lib.mkIf (shellDefault == "zsh") {
    home.shell.enableZshIntegration = true;

    programs.zsh = {
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

      oh-my-zsh.enable = true;

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
    };
  };
}

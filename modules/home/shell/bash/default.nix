{

  programs.bash = {
    enable = true;
    shellAliases = {
      v = "$EDITOR";
      f = "clear && microfetch";
      curl = "curlie";
      ls = "eza";
      lt = "eza --tree --level=2";
      ll = "eza  -lh --no-user --long";
      la = "eza -lah ";
      tree = "eza --tree ";
    };
    initExtra = ''
      nix() {
        case "$1" in
          shell|develop|build)
            nom "$@"
            ;;
          *)
            command nix "$@"
            ;;
        esac
      }
    '';
  };
}

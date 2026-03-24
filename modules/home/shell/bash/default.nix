{
  programs.bash = {
    enable = true;
    shellAliases = {
      sv = "sudoedit";
      v = "nvim";
      c = "clear";
      f = "clear && microfetch";
      man = "batman";
      curl = "curlie";
      cat = "bat";
      "nix-shell" = "nom-shell";
      "nix-build" = "nom-build";
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

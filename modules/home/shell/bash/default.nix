{ pkgs, ... }:
{
  home.packages = with pkgs; [
    flyline
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      v = "$EDITOR";
      c = "clear";
      f = "clear && microfetch";
      man = "batman";
      curl = "curlie";
      cat = "bat";
      "nix-shell" = "nom-shell";
      "nix-build" = "nom-build";
    };
    initExtra = ''
      enable -f ${pkgs.flyline}/lib/libflyline.so flyline

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

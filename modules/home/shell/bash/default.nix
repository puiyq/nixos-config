{ pkgs, ... }:
{
  home.packages = with pkgs; [
    flyline
    flycomp
    rgrc
  ];

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
      enable -f ${pkgs.flyline}/lib/libflyline.so flyline
      eval "$(rgrc --aliases --except curl --except ls)"

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

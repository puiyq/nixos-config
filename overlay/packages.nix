final: prev:
import ../pkgs {
  pkgs = prev;
  inherit (prev) lib;
}

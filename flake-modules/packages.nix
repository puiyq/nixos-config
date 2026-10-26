{
  perSystem =
    { pkgs, ... }:
    {
      packages = import ../pkgs pkgs pkgs.lib;
    };
}

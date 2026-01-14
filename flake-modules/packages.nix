{
  perSystem =
    { pkgs, ... }:
    {
      packages = import ../pkgs {
        inherit pkgs;
        inherit (pkgs) lib;
      };
    };
}

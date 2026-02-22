final: prev: {

  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };
    }
  );

  freecad-dev = prev.freecad.overrideAttrs (oldAttrs: {
    version = "weekly-2026.02.25";

    src = prev.fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      tag = "weekly-2026.02.25";
      fetchSubmodules = true;
      hash = "sha256-GW3JBUfg7nZpPa/j083H+PVAc5ZkqES9REAtaiFWOSE=";
    };
    patches = prev.lib.filter (
      p:
      !(prev.lib.hasInfix "OndselSolver-pkgconfig" (toString p))
      && !(prev.lib.hasInfix "fix-font-load-crash" (toString p))
      && !(prev.lib.hasInfix "8e04c0a3dd9435df0c2dec813b17d02f7b723b19" (toString p))
      && !(prev.lib.hasInfix "60aa5ff3730d77037ffad0c77ba96b99ef0c7df3" (toString p))
    ) oldAttrs.patches;
    postPatch = "";
    propagatedBuildInputs = [ prev.gmsh ];
  });

}

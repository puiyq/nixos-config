_final: prev: {
  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };

      inherit (prev.lixPackageSets.latest)
        nixpkgs-reviewFull
        nixpkgs-review
        nix-fast-build
        nix-eval-jobs
        nix-serve-ng
        nix-update
        nix-direnv
        nix-init
        colmena
        nurl
        nil
        ;
    }
  );
}

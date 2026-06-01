_final: prev: {
  inherit (prev.lixPackageSets.latest)
    nixpkgs-reviewFull
    nixpkgs-review
    nix-fast-build
    nix-eval-jobs
    nix-serve-ng
    nix-update
    nix-init
    colmena
    nurl
    nil
    ;
  bees = prev.bees_git;
  comma = prev.comma.override { nix = prev.lixPackageSets.latest.lix; };
  _7zz = prev._7zz.override {
    useUasm = true;
    enableUnfree = true;
  };
  linux-wallpaperengine = prev.linux-wallpaperengine.override {
    mpv = prev.mpv-unwrapped.override {
      nv-codec-headers-11 = null;
      alsaSupport = false;
      archiveSupport = false;
      bluraySupport = false;
      bs2bSupport = false;
      cacaSupport = false;
      cmsSupport = false;
      dvbinSupport = false;
      dvdnavSupport = false;
      javascriptSupport = false;
      openalSupport = false;
      rubberbandSupport = false;
      vdpauSupport = false;
      x11Support = false;
      zimgSupport = false;
    };
  };
  mpvpaper =
    (prev.mpvpaper.overrideAttrs (old: {
      version = "0-unstable-2026-03-29";

      src = prev.fetchFromGitHub {
        owner = "GhostNaN";
        repo = "mpvpaper";
        rev = "4de75e73b40ba9e953eaec9eaa7773e6c31ab08a";
        hash = "sha256-Q9BXr78rq47pZznrTuG0+6oHO4obOhBmNn/FRWtt5/Q=";
      };
    })).override
      {
        mpv = prev.mpv-unwrapped.override {
          nv-codec-headers-11 = null;
          alsaSupport = false;
          archiveSupport = false;
          bluraySupport = false;
          bs2bSupport = false;
          cacaSupport = false;
          cmsSupport = false;
          dvbinSupport = false;
          dvdnavSupport = false;
          javascriptSupport = false;
          openalSupport = false;
          rubberbandSupport = false;
          vdpauSupport = false;
          x11Support = false;
          zimgSupport = false;
        };
      };
  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };
    }
  );
}

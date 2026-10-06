_final: prev: {
  bees = prev.bees_git;
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
    prev.mpvpaper
    |> (
      p:
      p.overrideAttrs (_old: {
        version = "1.9";
        src = prev.fetchFromGitHub {
          owner = "GhostNaN";
          repo = "mpvpaper";
          tag = "1.9";
          hash = "sha256-FpwMhzYmbjwvbpJd6xDRka6h2bvgsqdopqP5deQKXSA=";
        };
      })
    )
    |> (
      p:
      p.override {
        mpv = prev.mpv-unwrapped.override {
          nv-codec-headers-11 = null;
          alsaSupport = false;
          archiveSupport = false;
          bluraySupport = false;
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
      }
    );
  qt6Packages = prev.qt6Packages.overrideScope (
    _final': prev': {
      # HACK: no more qt5
      fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

      # HACK: no more kde stuff
      fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };
    }
  );
  starship = prev.starship.overrideAttrs (
    let
      src = prev.fetchFromGitHub {
        owner = "starship";
        repo = "starship";
        rev = "d4d0459c5c24ba8f64663af8714f7858d7fb357b";
        hash = "sha256-mO+25Q+v7z5XUT7DVLRwDjW3htc+kmUOKavhuEM5654=";
      };
    in
    {
      version = "1.26.0-unstable-2026-10-05";
      inherit src;
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-5R2CdOA5FVWswVbGxdacRQXd+M1yTrSNJwSfBNhjomQ=";
      };
    }
  );
}

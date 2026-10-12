final: prev: {
  # keep-sorted start block=yes
  _7zz = prev._7zz.override {
    useUasm = true;
    enableUnfree = true;
  };
  bees = prev.bees_git;
  carapace = prev.carapace.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "1.8.1";
      src = prev.fetchFromGitHub {
        inherit (previousAttrs.src) owner repo;
        tag = "v${finalAttrs.version}";
        hash = "sha256-s/mPabd8JXrGjkeEDK/KU6/DyeLUnze5rPXT9By/HE0=";
      };
      vendorHash = "sha256-DcVTWwwQdQr89drvvPGBzWfZ5gV5FIe2xP+mpgWtzJY=";
    }
  );
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
    finalAttrs: previousAttrs: {
      version = "1.27.0";
      src = prev.fetchFromGitHub {
        inherit (previousAttrs.src) owner repo;
        tag = "v${finalAttrs.version}";
        hash = "sha256-Aq79POUoeKnG/gNG3rpmayhER61kiUCE8gsHGbvT66w=";
      };
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) src;
        hash = "sha256-m5UbV/9SpTpBga+PDaqwWi9k9W5BUZ+rz+t5dliJyjM=";
      };
    }
  );
  # keep-sorted end
}

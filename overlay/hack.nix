_final: prev: {
  # keep-sorted start block=yes
  _7zz = prev._7zz.override {
    useUasm = true;
    enableUnfree = true;
  };
  bees = prev.bees_git;
  mpvpaper =
    prev.mpvpaper
    |> (
      p:
      p.overrideAttrs (
        _finalAttrs: previousAttrs: {
          version = "1.9-unstable-2026-08-29";
          src = prev.fetchFromGitHub {
            inherit (previousAttrs.src) owner repo;
            rev = "fc5ed285d657c31fbd063b854884ea00e72d2d51";
            hash = "sha256-JOp8vxnBi4sl1vfdZrTrvB6Vb+mPu95fkw7Ev6TZcpU=";
          };
        }
      )
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
          pulseSupport = false;
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
  # keep-sorted end
}

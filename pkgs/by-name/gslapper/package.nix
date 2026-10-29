{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wrapGAppsNoGuiHook,
  wayland,
  wayland-protocols,
  libglvnd,
  systemd,
  gst_all_1,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gslapper";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Nomadcxx";
    repo = "gSlapper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ncnkWWHdHfXiVE8T5YwNCfkhvddfrB7LwfTsuwBTaY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libglvnd
    systemd
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-libav
  ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland wallpaper daemon for static images and video using GStreamer";
    longDescription = ''
      gSlapper is a wallpaper utility for Wayland that combines the best of
      swww and mpvpaper by allowing both static and video wallpapers. It uses
      GStreamer instead of libmpv, making it more efficient and NVIDIA
      friendly for Wayland.
    '';
    homepage = "https://github.com/Nomadcxx/gSlapper";
    changelog = "https://github.com/Nomadcxx/gSlapper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nikolaizombie1
    ];
    mainProgram = "gslapper";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gradle,
  jetbrains,
  autoPatchelfHook,
  fontconfig,
  libXinerama,
  libXrandr,
  file,
  gtk3,
  glib,
  cups,
  lcms2,
  alsa-lib,
  libvlc,
  libidn,
  pulseaudio,
  ffmpeg,
  libva,
  libdvbpsi,
  libogg,
  chromaprint,
  protobuf_21,
  libgcrypt,
  libdvdnav,
  libsecret,
  aribb24,
  libavc1394,
  libmpcdec,
  libvorbis,
  libebml,
  faad2,
  libjpeg8,
  libkate,
  librsvg,
  libsForQt5,
  libupnp,
  aalib,
  libcaca,
  libmatroska,
  libopenmpt-modplug,
  libsidplayfp,
  shine,
  libarchive,
  gnupg,
  srt,
  libshout,
  ffmpeg_6,
  libmpeg2,
  xcbutilkeysyms,
  lirc,
  lua5_2,
  taglib,
  libspatialaudio,
  libmtp,
  speexdsp,
  libsamplerate,
  sox,
  libmad,
  libnotify,
  taglib_1,
  zvbi,
  libdc1394,
  libcddb,
  libbluray,
  libdvdread,
  libvncserver,
  twolame,
  samba,
  libnfs,
  flac,
  libxml2,
  boost,
  libXpm,
  thrift,
  writeShellScript,
  nix-update,
}:
let
  thrift20 = thrift.overrideAttrs (old: {
    version = "0.20.0";
    src = fetchFromGitHub {
      owner = "apache";
      repo = "thrift";
      tag = "v0.20.0";
      hash = "sha256-cwFTcaNHq8/JJcQxWSelwAGOLvZHoMmjGV3HBumgcWo=";
    };
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.10"
    ];

    patches = (old.patches or [ ]) ++ [
      # Fix build with gcc15
      # https://github.com/apache/thrift/pull/3078
      (fetchpatch {
        name = "thrift-add-missing-cstdint-include-gcc15.patch";
        url = "https://github.com/apache/thrift/commit/947ad66940cfbadd9b24ba31d892dfc1142dd330.patch";
        hash = "sha256-pWcG6/BepUwc/K6cBs+6d74AWIhZ2/wXvCunb/KyB0s=";
      })
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "animeko";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "open-ani";
    repo = "animeko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eP1v/o9qUk8qG+n1cJRmlgu2l06hFZLeUN/X06qAVpY=";
    fetchSubmodules = true;
  };

  # copy currentAniBuildConfig from upstream release asset to local.properties

  postPatch = ''
    echo "ani.dandanplay.app.id=2qkvdr35cy" >> local.properties
    echo "ani.dandanplay.app.secret=WspqhGkCD4DQbIUiXTPprrGmpn3YHFeX" >> local.properties
    echo "ani.sentry.dsn=https://e548a2f9a8d7dbf1785da0b1a90e1595@o4508788947615744.ingest.us.sentry.io/4508788953448448" >> local.properties
    echo "ani.analytics.server=https://us.i.posthog.com" >> local.properties
    echo "ani.analytics.key=phc_7uXkMsKVXfFP9ERNbTT5lAHjVLYAskiRiakjxLROrHw" >> local.properties
    echo "kotlin.native.ignoreDisabledTargets=true" >> local.properties
    echo "ani.enable.ios=false" >> local.properties
    echo "ani.enable.firebase=false" >> local.properties
    echo "ani.compose.hot.reload=false" >> local.properties

    sed -i "s/^version.name=.*/version.name=${finalAttrs.version}/" gradle.properties
    sed -i "s/^package.version=.*/package.version=${finalAttrs.version}/" gradle.properties

    substituteInPlace app/shared/app-platform/src/desktopMain/kotlin/platform/AniCefApp.kt \
      --replace-fail "CefLog.init(jcefConfig.cefSettings)" \
                     "CefLog.init(jcefConfig.cefSettings.log_file, jcefConfig.cefSettings.log_severity)"
  '';

  gradleBuildTask = ":app:desktop:createReleaseDistributable";

  gradleUpdateTask = finalAttrs.gradleBuildTask;

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
    silent = false;
    useBwrap = false;
  };

  env.JAVA_HOME = jetbrains.jdk;

  gradleFlags = [
    "-Dorg.gradle.java.home=${jetbrains.jdk}"
    "-Dorg.gradle.configureondemand=true"
  ];

  nativeBuildInputs = [
    gradle
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    libXinerama
    libXrandr
    file
    shine
    libmpeg2
    gtk3
    glib
    cups
    lcms2
    alsa-lib
    libidn
    pulseaudio
    ffmpeg
    faad2
    libjpeg8
    libkate
    librsvg
    libXpm
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtx11extras
    libupnp
    aalib
    libcaca
    libva
    libdvbpsi
    libogg
    chromaprint
    protobuf_21
    libgcrypt
    libsecret
    aribb24
    twolame
    libmpcdec
    libvorbis
    libebml
    libmatroska
    libopenmpt-modplug
    libavc1394
    libmtp
    libsidplayfp
    libarchive
    gnupg
    srt
    libshout
    ffmpeg_6
    xcbutilkeysyms
    lirc
    lua5_2
    taglib
    libspatialaudio
    speexdsp
    libsamplerate
    sox
    libmad
    libnotify
    zvbi
    libdc1394
    libcddb
    libbluray
    libdvdread
    libvncserver
    samba
    libnfs
    taglib_1
    libdvdnav
    flac
    libxml2
    boost
    thrift20
  ];

  dontWrapQtApps = true;

  doCheck = false;

  installPhase = ''
    runHook preInstall

    cp -r app/desktop/build/compose/binaries/main-release/app/Ani $out
    chmod +x $out/lib/runtime/lib/jcef_helper
    substituteInPlace app/desktop/appResources/linux-x64/animeko.desktop \
      --replace-fail "icon" "animeko"
    install -Dm644 app/desktop/appResources/linux-x64/animeko.desktop $out/share/applications/animeko.desktop
    install -Dm644 app/desktop/appResources/linux-x64/icon.png $out/share/pixmaps/animeko.png

    runHook postInstall
  '';

  preFixup = ''
    # Remove prebuilt vlc and use NixOS version
    rm -r $out/lib/app/resources/lib
    ln -sf ${libvlc}/lib $out/lib/app/resources/
  '';

  passthru.updateScript = writeShellScript "update-animeko" ''
    ${lib.getExe nix-update} animeko
    $(nix-build -A animeko.mitmCache.updateScript)
  '';

  meta = {
    description = "One-stop platform for finding, following and watching anime";
    homepage = "https://github.com/open-ani/animeko";
    mainProgram = "Ani";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ puiyq ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = [ "x86_64-linux" ];
  };
})

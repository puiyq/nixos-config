{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (_finalAttrs: {
  pname = "uosc-danmaku";
  version = "0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "Tony15246";
    repo = "uosc_danmaku";
    rev = "d896f179aac1c9e7e657664dbe8a69567a9a4900";
    hash = "sha256-IDxylx61HTYki34Ehy3hgHDua8F1b8xEV0IW8xjV6uI=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 main.lua $out/share/mpv/scripts/uosc_danmaku/main.lua
    cp -r modules apis dicts sites $out/share/mpv/scripts/uosc_danmaku/

    runHook postInstall
  '';

  passthru = {
    updateScript = gitUpdater { };
    scriptName = "uosc_danmaku";
  };

  meta = {
    description = "Load DanDanPlay danmaku in MPV player";
    homepage = "https://github.com/Tony15246/uosc_danmaku";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
  };
})

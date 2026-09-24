{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:
stdenvNoCC.mkDerivation (_finalAttrs: {
  pname = "uosc-danmaku";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "Tony15246";
    repo = "uosc_danmaku";
    rev = "55f3aea77fb9d9357baa86eebd104eab95248699";
    hash = "sha256-8ihBDgdUdMJc5/M2+yFf8LWqPkBFtYcrPPpYqky6AME=";
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

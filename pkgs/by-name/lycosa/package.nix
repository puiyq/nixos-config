{
  lib,
  stdenv,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  typescript,
  electron,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lycosa";
  version = "0.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  pnpm = pnpm_11;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./package.json
      ./pnpm-lock.yaml
      ./tsconfig.json
      ./lycosa.png
      ./src
    ];
  };

  nativeBuildInputs = [
    typescript
    pnpmConfigHook
    pnpmBuildHook
    finalAttrs.pnpm
    copyDesktopItems
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpm
      ;
    fetcherVersion = 4;
    hash = "sha256-SXAbwulC7qV+EuHdILv/o5sWOfq1PF3yRV4Dr7WnZIA=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  desktopItems = [
    (makeDesktopItem {
      name = "lycosa";
      desktopName = "Lycosa";
      exec = "lycosa";
      icon = "lycosa";
      comment = finalAttrs.meta.description;
      categories = [
        "Utility"
        "HardwareSettings"
        "Settings"
      ];
      terminal = false;
    })
  ];

  pnpmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/aula
    cp -r dist $out/lib/aula

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp lycosa.png $out/share/icons/hicolor/512x512/apps/lycosa.png

    mkdir -p $out/bin

    makeBinaryWrapper ${lib.getExe electron} $out/bin/lycosa \
        --add-flags "$out/lib/aula/dist/main.js"

    runHook postInstall
  '';

  meta = {
    mainProgram = "lycosa";
    description = "AULA HERO keyboard Electron WebHID wrapper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    platforms = [ "x86_64-linux" ];
  };
})

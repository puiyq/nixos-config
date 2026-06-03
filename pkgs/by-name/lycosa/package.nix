{
  lib,
  stdenv,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeDesktopItem,
  copyDesktopItems,
  typescript,
  electron,
  withoutBwrap ? false,
  makeBinaryWrapper,
  bubblewrap,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lycosa";
  version = "0.1.0";

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
    finalAttrs.pnpm
    copyDesktopItems
  ]
  ++ lib.optional withoutBwrap makeBinaryWrapper;

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

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  # workaround for my system-wide mimalloc usage
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/aula
    cp -r dist $out/lib/aula

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp lycosa.png $out/share/icons/hicolor/512x512/apps/lycosa.png

    mkdir -p $out/bin
  ''
  + (
    if withoutBwrap then
      ''
        makeBinaryWrapper ${lib.getExe electron} $out/bin/lycosa \
            --add-flags "$out/lib/aula/dist/main.js"
      ''
    else
      # workaround for my system-wide mimalloc usage
      ''
        cat > $out/bin/lycosa <<EOF
        #!/usr/bin/env bash
        set -euo pipefail

        exec ${lib.getExe bubblewrap} \
          --bind / / \
          --proc /proc \
          --dev /dev \
          --dev-bind /dev/dri /dev/dri \
          \$(for h in /dev/hidraw*; do
              [ -e "\$h" ] && echo "--dev-bind \$h \$h"
          done) \
          --bind /dev/null \$(realpath /etc/ld-nix.so.preload) \
          --die-with-parent \
          -- \
          ${lib.getExe electron} $out/lib/aula/dist/main.js
        EOF

        chmod +x $out/bin/lycosa
      ''
  )
  + ''
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

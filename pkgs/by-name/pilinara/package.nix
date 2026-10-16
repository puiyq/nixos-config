{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  flutter,
  buildPackages,
  makeBinaryWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  mpv-unwrapped,
  webkitgtk_4_1,
}:
flutter.buildFlutterApplication (finalAttrs: {
  pname = "pilinara";
  version = "2.1.6";

  passthru.srcInfo = lib.importJSON ./src-info.json;
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  src = fetchFromGitHub {
    owner = "Starfallan";
    repo = "PiliNara";
    inherit (finalAttrs.passthru.srcInfo) rev hash;
  };

  patches = [
    ./disable-auto-update.patch
    (fetchpatch2 {
      name = "fix-refresh-layout-semantics.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-fix-refresh-layout-semantics.patch?h=pilinara";
      hash = "sha256-+QslvLgvrhWE9bmWpHQUfrlSWWGfZj0Y0GZZ2suKaDM=";
    })
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    webkitgtk_4_1
  ];

  preBuild = ''
    # Dart's native build hooks filter PKG_CONFIG_PATH out of the environment.
    mkdir -p .pkg-config
    makeBinaryWrapper ${lib.getExe buildPackages.pkg-config} "$PWD/.pkg-config/pkg-config" \
      --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH"
    export PATH="$PWD/.pkg-config:$PATH"

    # see lib/scripts/build.ps1
    cat <<JSON > pili_release.json
    {
      "pili.hash": "${finalAttrs.passthru.srcInfo.rev}",
      "pili.name": "${finalAttrs.version}",
      "pili.code": ${toString finalAttrs.passthru.srcInfo.revCount},
      "pili.time": ${toString finalAttrs.passthru.srcInfo.commitDate}
    }
    JSON

    export FLUTTER_ROOT="$PWD/.flutter-sdk"
    cp -aL '${flutter.sdk}' "$FLUTTER_ROOT"
    chmod -R u+w "$FLUTTER_ROOT"

    materialUiPackageDir="$(jq -r '
      .packages[]
      | select(.name == "material_ui")
      | .rootUri
      | ltrimstr("file://")
      | rtrimstr("/.")
    ' .dart_tool/package_config.json)"
    materialUiCacheDir="$PWD/.material_ui"
    cp -a "$materialUiPackageDir" "$materialUiCacheDir"
    chmod -R u+w "$materialUiCacheDir"

    flutterPatches=(
      modal_barrier text_selection mouse_cursor image_anim layout_builder
      navigation_drawer popup_menu fab null_safety_for_selectable_region
      selectable_region editable_text text_field scroll_position scrollable
      scrollable_gesture draggable_scrollable_sheet scaffold text text_painter
      sliver refresh_indicator double_tap_gesture
    )
    for patch in "''${flutterPatches[@]}"; do
      patch -p1 -d "$FLUTTER_ROOT" < "$PWD/lib/scripts/$patch.patch"
    done

    materialPatches=(
      modal_barrier_material navigation_drawer popup_menu fab text_field
      scaffold refresh_indicator tabs
    )
    for patch in "''${materialPatches[@]}"; do
      patchFile="lib/scripts/material/$patch.patch"
      sed -i 's/\r$//' "$patchFile"
      patch -p1 -d "$materialUiCacheDir" < "$PWD/$patchFile"
    done

    # point package resolution at the patched Flutter SDK and material_ui.
    jq --arg flutterRoot "file://$FLUTTER_ROOT" --arg materialRoot "file://$materialUiCacheDir/." '
      .packages |= map(
        .rootUri = (
          if .name == "material_ui" then $materialRoot
          elif (.rootUri | contains("flutter-sdk-")) then
            "\($flutterRoot)/\(if .name == "sky_engine" then "bin/cache/pkg/sky_engine" else "packages/\(.name)" end)/."
          else .rootUri
          end
        )
      )
    ' .dart_tool/package_config.json > .dart_tool/package_config.json.tmp
    mv .dart_tool/package_config.json.tmp .dart_tool/package_config.json
  '';

  flutterBuildFlags = [ "--dart-define-from-file=pili_release.json" ];

  extraWrapProgramArgs = "--prefix LD_LIBRARY_PATH : $out/app/pilinara/lib";

  postInstall = ''
    declare -A sizes=(
      [mdpi]=128
      [hdpi]=192
      [xhdpi]=256
      [xxhdpi]=384
      [xxxhdpi]=512
    )
    for var in "''${!sizes[@]}"; do
      width=''${sizes[$var]}
      install -Dm644 "android/app/src/main/res/drawable-$var/splash.png" \
        "$out/share/icons/hicolor/''${width}x$width/apps/pilinara.png"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "pilinara";
      desktopName = "PiliNara";
      comment = finalAttrs.meta.description;
      exec = "pilinara";
      icon = "pilinara";
      categories = [
        "Video"
        "AudioVideo"
        "Player"
      ];
      terminal = false;
      startupWMClass = "com.example.pilinara";
    })
  ];

  passthru.updateScript = ./update.nu;

  meta = {
    description = "Third-party Bilibili client developed in Flutter";
    homepage = "https://github.com/Starfallan/PiliNara";
    changelog = "https://github.com/Starfallan/PiliNara/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ puiyq ];
    platforms = lib.platforms.linux;
    mainProgram = "pilinara";
  };
})

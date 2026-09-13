{
  lib,
  fetchFromGitHub,
  flutter,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  gitMinimal,
  powershell,
  alsa-lib,
  mpv-unwrapped,
  libplacebo,
  libappindicator,
  webkitgtk_4_1,
}:
let
  src-info = lib.importJSON ./src-info.json;
in
flutter.buildFlutterApplication (finalAttrs: {
  pname = "pilinara";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "Starfallan";
    repo = "PiliNara";
    inherit (src-info) rev hash;
  };

  patches = [
    ./disable-auto-update.patch

    # lib/scripts/patch.ps1 normally deletes material_ui
    # and runs `flutter pub get` to restore it.
    # in nix we provide a writable pub cache ourselves
    ./no-remove-before-patch.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    gitMinimal # used extensively in lib/scripts/patch.ps1
    powershell
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    libplacebo
    libappindicator
    webkitgtk_4_1
  ];

  preBuild = ''
    # see lib/scripts/build.ps1
    cat <<JSON > pili_release.json
    {
      "pili.hash": "${src-info.rev}",
      "pili.name": "${finalAttrs.version}",
      "pili.code": ${toString src-info.revCount},
      "pili.time": ${toString src-info.commitDate}
    }
    JSON

    export FLUTTER_ROOT="$PWD/.flutter-sdk"
    cp -aL '${flutter.sdk}' "$FLUTTER_ROOT"
    chmod -R u+w "$FLUTTER_ROOT"
    git -C "$FLUTTER_ROOT" reset --hard HEAD

    export PUB_CACHE="$PWD/.pub-cache"
    mkdir -p "$PUB_CACHE/hosted/pub.dev"

    # build a writable pub cache with the packages that patch.ps1 patches
    buildWritablePubCache() {
      packageDir="$(jq --arg packageName "$1" -r '
        .packages[]
        | select(.name == $packageName)
        | .rootUri
        | ltrimstr("file://")
        | rtrimstr("/.")
      ' .dart_tool/package_config.json)"
      cacheDir="$PUB_CACHE/hosted/pub.dev/$(basename "$packageDir" | sed 's/^[^-]*-pub-//')"
      cp -a "$packageDir" "$cacheDir"
      chmod -R u+w "$cacheDir"
      echo "$cacheDir"
    }
    materialUiCacheDir="$(buildWritablePubCache material_ui)"
    buildWritablePubCache cupertino_ui > /dev/null

    HOME="$PWD" GITHUB_WORKSPACE="$PWD" pwsh lib/scripts/patch.ps1 Linux

    # point package resolution at the patched Flutter SDK and material_ui.
    jq --arg flutterRoot "file://$FLUTTER_ROOT" --arg materialRoot "file://$materialUiCacheDir/." '
      .packages |= map(
        if (.rootUri | contains("flutter-sdk-")) then
          if .name == "sky_engine" then .rootUri = "\($flutterRoot)/bin/cache/pkg/sky_engine/."
          else .rootUri = "\($flutterRoot)/packages/\(.name)/."
          end
        elif .name == "material_ui" then .rootUri = $materialRoot
        else .
        end
      )
    ' .dart_tool/package_config.json > .dart_tool/package_config.json.tmp
    mv .dart_tool/package_config.json.tmp .dart_tool/package_config.json
  '';

  flutterBuildFlags = [ "--dart-define-from-file=pili_release.json" ];

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

  postFixup = ''
    wrapProgram $out/bin/pilinara \
      --prefix LD_LIBRARY_PATH : "$out/app/pilinara/lib"
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

  passthru.updateScript = ./update.sh;

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

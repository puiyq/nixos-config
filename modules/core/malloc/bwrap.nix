{
  pkgs,
  lib,
  ...
}:
let
  mkNoPreloadWrapper =
    package:
    let
      binaryName = package.meta.mainProgram or package.pname;
      executable = lib.getExe package;
      wrapper = pkgs.writeShellScriptBin binaryName ''
        exec ${lib.getExe pkgs.bubblewrap} \
          --bind / / \
          --dev /dev \
          --proc /proc \
          --dev-bind /dev/dri /dev/dri \
           $(for h in /dev/hidraw*; do [ -e "$h" ] && echo "--dev-bind $h $h"; done) \
          --bind /dev/null "$(readlink -f /etc/ld-nix.so.preload)" \
          --die-with-parent \
          -- ${executable} "$@"
      '';
      patchedDesktops = pkgs.runCommand "${package.pname}-desktops" { } ''
        mkdir -p $out/share/applications
        for f in ${package}/share/applications/*.desktop; do
          [ -f "$f" ] || continue
          dest=$out/share/applications/$(basename "$f")
          if grep -q ${executable} "$f"; then
            substitute "$f" "$dest" \
              --replace-fail ${executable} ${wrapper}/bin/${binaryName}
          else
            cp "$f" "$dest"
          fi
        done
      '';
    in
    pkgs.symlinkJoin {
      name = package.pname + "-no-preload";
      paths = [
        (lib.hiPrio wrapper)
        patchedDesktops
        package
      ];
    };
in
{
  environment.memoryAllocator.provider = "mimalloc";

  environment.systemPackages = map mkNoPreloadWrapper [
    (pkgs.vivaldi.override { proprietaryCodecs = true; })
    (pkgs.prismlauncher.override {
      additionalPrograms = [ pkgs.ffmpeg ];
      textToSpeechSupport = false;
      jdks = [ pkgs.graalvmPackages.graalvm-ce ];
    })
    pkgs.zotero
  ];
}

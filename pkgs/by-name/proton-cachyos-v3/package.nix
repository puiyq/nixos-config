{
  lib,
  stdenvNoCC,
  fetchurl,
  writeShellApplication,
  nix-update,
  # Can be overridden to alter the display name in steam
  # This could be useful if multiple versions should be installed together
  steamDisplayName ? "Proton CachyOS v3",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos-v3";
  version = "10.0-20260330-slr";

  src = fetchurl {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${finalAttrs.version}/proton-cachyos-${finalAttrs.version}-x86_64_v3.tar.xz";
    hash = "sha256-xQxG7j1bhWhI2qhTQp+AsJeqVZk9ljXMibYgcVFqybY=";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir -p $steamcompattool
    cp -a . $steamcompattool/

    runHook postInstall
  '';

  preFixup = ''
    # Allow to keep the same name between updates
    sed -i -r 's|"proton-.*"|"${steamDisplayName}"|' "$steamcompattool/compatibilitytool.vdf"
  '';

  passthru.updateScript = writeShellApplication {
    name = "update-proton-cachyos-v3";
    runtimeInputs = [ nix-update ];
    text = ''
      nix-update proton-cachyos-v3 -F -vr "cachyos-(.*)" --use-github-releases
    '';
  };

  meta = {
    description = ''
      Compatibility tool for Steam Play based on Wine and additional components (patched and built by CachyOS).

      (This is intended for use in the `programs.steam.extraCompatPackages` option only.)
    '';
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

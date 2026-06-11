{
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  cargo-toml = (lib.importTOML ./Cargo.toml).package;

  inherit (finalAttrs.cargo-toml) name version;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./Cargo.toml
      ./Cargo.lock
      ./src
    ];
  };
  cargoLock.lockFile = ./Cargo.lock;

  __structuredAttrs = true;

  meta = {
    inherit (finalAttrs.cargo-toml) description;
    mainProgram = finalAttrs.cargo-toml.name;
    license = lib.getLicenseFromSpdxId finalAttrs.cargo-toml.license;
    maintainers = with lib.maintainers; [ puiyq ];
  };
})

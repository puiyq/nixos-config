{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flycomp";
  version = "0-unstable-2026-08-12";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flycomp";
    rev = "2f3553784131e3e04887bbd17a18458b7aaaf9f2";
    hash = "sha256-fxyhQpOohwxZ8v/3opFpAbPoTOHQqEx/PtvHVop50TM=";
  };

  cargoHash = "sha256-1nP19Y6XHaVrXRF9RqurH0rgXyu+CAYKxq3jEodLVRQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate shell completion scripts dynamically from CLI --help outputs and Unix man pages.";
    homepage = "https://github.com/HalFrgrd/flycomp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "flycomp";
  };
})

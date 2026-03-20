{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wakatime-ls";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "wakatime";
    repo = "zed-wakatime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jmm+eRHMNBkc6ZzadvkWrfsb+bwEBNM0fnXU4dJ0NgE=";
  };

  cargoHash = "sha256-x2axmHinxYZ2VEddeCTqMJd8ok0KgAVdUhbWaOdRA30=";

  cargoBuildFlags = [
    "--package"
    "wakatime-ls"
  ];
  cargoTestFlags = [
    "--package"
    "wakatime-ls"
  ];

  meta = {
    description = "Zed plugin for automatic time tracking and metrics generated from your programming activity";
    homepage = "https://github.com/wakatime/zed-wakatime";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "wakatime-ls";
  };
})

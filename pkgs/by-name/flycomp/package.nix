{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "flycomp";
  version = "1.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flycomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V4JsEvqLcEK7r9+6TiMqGsip7DIsjHg5D92HDlGdLpU=";
  };

  cargoHash = "sha256-+Nhes9V6HsRJ2ljpieSYvJ4Ywk7WFnjhwgJhpGWnUg8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate shell completion scripts dynamically from CLI --help outputs and Unix man pages.";
    homepage = "https://github.com/HalFrgrd/flycomp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "flycomp";
  };
})

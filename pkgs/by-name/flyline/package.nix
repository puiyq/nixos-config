{
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "flyline";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "HalFrgrd";
    repo = "flyline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KciBcUsoMCGuw8bHlVBDHAB55lDfyeGoJxBldmj0MVs=";
  };

  cargoHash = "sha256-zTL33etJpEHGPOrw+mUR6JUP1jzPdHBrGYJZjea13WU=";

  checkFlags = [
    # docker_integration_tests fails
    "--skip=test_bash_3_2_57"
    "--skip=test_bash_4_4_18"
    "--skip=test_bash_4_4_rc1"
    "--skip=test_bash_5_0"
    "--skip=test_bash_5_3"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bash plugin to replace readline for a modern line editing experience";
    homepage = "https://github.com/HalFrgrd/flyline";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      lwb-2021
      puiyq
    ];
  };
})

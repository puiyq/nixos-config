{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage (finalAttr: {
  pname = "bilibili-tui";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "MareDevi";
    repo = "bilibili-tui";
    rev = "v${finalAttr.version}";
    hash = "sha256-LS8w0uKit69CYVvkhYTcPsYikD0Qy6W9oP77vBMNVxo=";
  };

  cargoHash = "sha256-LOo4wg6Q0oEBlDKKZowIEuOxXqauWqHAo0kK+PKo78g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = {
    description = "Terminal user interface (TUI) client for Bilibili";
    homepage = "https://maredevi.moe/projects/bilibili-tui/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "bilibili-tui";
  };
})

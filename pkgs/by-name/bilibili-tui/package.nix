{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  pkg-config,
  makeWrapper,
  openssl,
  cacert,
  mpv-unwrapped,
  yt-dlp-light,
  withMpv ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bilibili-tui";
  version = "0-unstable-2026-06-07";

  src = fetchFromGitHub {
    owner = "puiyq";
    repo = "bilibili-tui";
    rev = "cad75bf2973279bfd0c5138a20c1b76b628bc26e";
    hash = "sha256-S56zZa0ySKxfNYzqsxhhi3tbxdTyChparz0JZsDkrYI=";
  };

  cargoHash = "sha256-CqI3+kOdoSnc3YEhXitVKBNSHoUnCkilFtP4lFsZUtY=";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  nativeCheckInputs = [ cacert ];

  # Wrap mpv as fallback; users should prefer their system's mpv in PATH
  postInstall = lib.optionalString withMpv ''
    wrapProgram $out/bin/bilibili-tui \
      --suffix PATH : ${
        lib.makeBinPath [
          mpv-unwrapped
          yt-dlp-light
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal user interface (TUI) client for Bilibili";
    homepage = "https://maredevi.moe/projects/bilibili-tui/";
    downloadPage = "https://github.com/MareDevi/bilibili-tui/releases";
    changelog = "https://github.com/MareDevi/bilibili-tui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ puiyq ];
    mainProgram = "bilibili-tui";
  };
})

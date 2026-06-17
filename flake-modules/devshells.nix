{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        # keep-sorted start block=yes
        C = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [ clang-tools ];
        };
        R = pkgs.mkShellNoCC {
          packages = with pkgs; [
            air-formatter
            (rWrapper.override {
              packages = with pkgs.rPackages; [
                languageserver
                lintr
                styler
              ];
            })
          ];
        };
        asm = pkgs.mkShellNoCC {
          packages = with pkgs; [ asm-lsp ];
        };
        go = pkgs.mkShellNoCC {
          packages = with pkgs; [ go ];
        };
        python = pkgs.mkShell {
          packages = with pkgs; [
            # keep-sorted start
            python3
            ruff
            ty
            uv
            # keep-sorted end
          ];
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [
            # keep-sorted start
            cargo
            clippy
            rust-analyzer
            rustc
            rustfmt
            rustlings
            # keep-sorted end
          ];
        };
        typescript = pkgs.mkShell {
          packages = with pkgs; [
            nodejs-slim
            pnpm
            typescript
          ];
        };
        typst = pkgs.mkShellNoCC {
          packages = with pkgs; [ typst ];
        };
        # keep-sorted end
      };
    };
}

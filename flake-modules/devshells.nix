{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        # keep-sorted start block=yes
        C = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        go = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [ go ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        python = pkgs.mkShell {
          packages = with pkgs; [
            # keep-sorted start
            python314
            uv
            # keep-sorted end
          ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [
            # keep-sorted start
            cargo
            rustc
            rustlings
            clippy
            # keep-sorted end
          ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        typescript = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
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

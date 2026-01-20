{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        C = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        go = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [ go ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages = with pkgs; [
            rustc
            cargo
            rustlings
          ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        python = pkgs.mkShell {
          packages = with pkgs; [
            python314
            uv
          ];
          nativeBuildInputs = [ ];
          buildInputs = [ ];
        };
        typst = pkgs.mkShellNoCC {
          packages = with pkgs; [ typst ];
        };
      };
    };
}

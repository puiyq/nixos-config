{ lib, ... }:
let
  mkLanguageOption = name: {
    enable = lib.mkEnableOption "Zed ${name} language support";
  };
  mkBuiltinLanguageOption = name: {
    enable = lib.mkOption {
      default = true;
      example = false;
      description = "Whether to enable Zed ${name} language support.";
      type = lib.types.bool;
    };
  };
in
{
  imports = [
    ./assembly.nix
    ./nix.nix
    ./python.nix
    ./typst.nix
    ./c.nix
    ./json.nix
    ./r.nix
    ./wakatime.nix
  ];

  options.programs.zed-editor.languages = {
    assembly = mkLanguageOption "Assembly";
    nix = mkLanguageOption "Nix";
    typst = mkLanguageOption "Typst";
    r = mkLanguageOption "R";

    # Built-in languages: Zed has native support for these,
    # so their LSP tooling is enabled by default.
    c = mkBuiltinLanguageOption "C/C++";
    json = mkBuiltinLanguageOption "JSON";
    python = mkBuiltinLanguageOption "Python";
  };
}

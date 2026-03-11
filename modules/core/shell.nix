{ lib, config, ... }:
let
  shell = config.shell.default;
in
{
  options.shell.default = lib.mkOption {
    type = lib.types.enum [
      "zsh"
      "fish"
    ];
    default = "zsh";
    description = "Select the interactive shell configuration to enable (zsh or fish).";
  };

  config = {
    programs = lib.mkMerge [
      {
        ${shell}.enable = true;
      }
      (lib.mkIf (shell == "fish") {
        fish.useBabelfish = true;
      })
    ];
  };
}

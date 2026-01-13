{ pkgs, lib }:
let
  customArgs = {
    bilibili-tui = {
      withMpv = false;
    };
  };
in
lib.mapAttrs (name: _: pkgs.callPackage ../pkgs/${name} (customArgs.${name} or { })) (
  lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists ../pkgs/${name}/default.nix
  ) (builtins.readDir ../pkgs)
)

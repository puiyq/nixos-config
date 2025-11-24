{
  host,
  lib,
  ...
}:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap;
in
{
  nix = {
    registry.nixpkgs = lib.mkForce {
      from = {
        type = "indirect";
        id = "nixpkgs";
      };
      to = {
        type = "github";
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable";
      };
    };
    settings = {
      eval-cores = 0;
      extra-nix-path = lib.mkForce "";
      download-buffer-size = 250000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://puiyq.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "puiyq.cachix.org-1:x3l4E/KXWxCSELeZlxB52NVOfof240vPjIZUEQp5RHw="
      ];
      trusted-users = [
        "@wheel"
      ];
    };
  };
  time.timeZone = "Asia/Kuching";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "25.05"; # Do not change!
}

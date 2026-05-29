{
  pkgs,
  inputs,
  username,
  config,
  ...
}:

{
  imports = [ inputs.selector4nix.nixosModules.selector4nix ];

  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    channel.enable = false;
    settings = {
      use-xdg-base-directories = true;
      auto-allocate-uids = true;
      auto-optimise-store = true;
      allow-import-from-derivation = false;
      keep-going = true;
      use-cgroups = true;
      http3 = true;

      experimental-features = [
        "auto-allocate-uids"
        "nix-command"
        "flakes"
        "cgroups"
      ];

      system-features = [
        "gccarch-znver4"
        "uid-range"
      ];

      substituters = [
        "https://cache.nixos.org"

        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      ];

      trusted-users = [ "${username}" ];
      allowed-users = [ "@users" ];
    };
    extraOptions = ''
      !include ${config.sops.templates."access-tokens".path}
    '';
  };

  services.selector4nix = {
    enable = true;
    configureSubstituter = "overwrite";
    settings = {
      substituters = [
        {
          url = "https://cache.nixos.org/";
        }
        {
          url = "https://cache.garnix.io/";
          storage_url = "https://garnix-cache.com/";
        }
        {
          url = "https://nix-community.cachix.org";
        }
        {
          url = "https://attic.xuyh0120.win/lantian";
        }
      ];
    };
  };
}

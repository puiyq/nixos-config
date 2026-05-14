{
  pkgs,
  username,
  config,
  ...
}:

{
  nix = {
    package = pkgs.lixPackageSets.latest.lix;

    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    channel.enable = false;
    settings = {
      use-xdg-base-directories = true;
      auto-allocate-uids = true;
      auto-optimise-store = true;
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

      extra-substituters = [
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];

      extra-trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
}

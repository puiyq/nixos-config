{
  inputs,
  username,
  config,
  ...
}:

{
  imports = [ inputs.lix-module.nixosModules.default ];

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    channel.enable = false;
    settings = {
      use-xdg-base-directories = true;
      auto-allocate-uids = true;
      auto-optimise-store = true;
      keep-going = true;
      use-cgroups = true;

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
        "https://nix-community.cachix.org"
        "https://puiyq.cachix.org"
        "https://cache.garnix.io"
        "https://niri.cachix.org"
      ];

      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "puiyq.cachix.org-1:x3l4E/KXWxCSELeZlxB52NVOfof240vPjIZUEQp5RHw="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];

      trusted-users = [ "${username}" ];
      allowed-users = [ "@users" ];
    };
    extraOptions = ''
      !include ${config.sops.templates."access-tokens".path}
    '';
  };

  nixpkgs.config.allowUnfree = true;
}

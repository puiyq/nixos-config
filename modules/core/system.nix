{ lib, username, ... }:
{
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    channel.enable = false;
    settings = {
      eval-cores = 0;
      lazy-trees = true;
      download-buffer-size = 250000000;
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
      substituters = lib.mkAfter [
        "https://nix-community.cachix.org"
        "https://puiyq.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "puiyq.cachix.org-1:x3l4E/KXWxCSELeZlxB52NVOfof240vPjIZUEQp5RHw="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      trusted-users = [ username ];
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

  documentation.info.enable = false;
  documentation.nixos.enable = false;
  home-manager.users.puiyq.manual.manpages.enable = false;

  environment.defaultPackages = [ ];
  system = {
    etc.overlay = {
      #enable = true;
      #mutable = false;
    };
    #nixos-init.enable = true;
    tools = {
      nixos-generate-config.enable = false;
      nixos-option.enable = false;
      nixos-version.enable = false;
      nixos-install.enable = false;
      nixos-enter.enable = false; # chroot tool
    };
    stateVersion = "25.11"; # Do not change! Unless you read all the section of the release notes.
  };
}

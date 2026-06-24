{ pkgs, lib, ... }:

{
  services = {
    # Performance
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
    };
    swapspace.enable = true;
    scx-loader = {
      enable = true;
      schedsPackages = [ pkgs.scx.rustscheds ];
      config = {
        default_sched = "scx_lavd";
        scheds = {
          scx_lavd = {
            auto_mode = [
              "--autopower"
              "--no-freq-scaling"
            ];
          };
        };
      };
    };

    # Peripherals
    kmscon = {
      enable = true;
      config = {
        hwaccel = true;
        font-size = lib.mkForce 21;
      };
    };
    speechd.enable = false;
    fwupd.enable = true;
    libinput = {
      enable = true; # Input Handling
      touchpad.disableWhileTyping = true;
    };

    # Storage
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    beesd.filesystems = {
      "root" = {
        spec = "/";
        hashTableSizeMB = 1024;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
          "--thread-count"
          "8"
          "--throttle-factor"
          "1.0"
        ];
      };
    };
    fstrim.enable = true; # SSD Optimizer
    gvfs = {
      enable = true; # For Mounting USB & More
      package = pkgs.gvfs;
    };
  };
}

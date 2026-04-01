{ pkgs, ... }:

{
  programs = {
    # Shell & Editors
    fish = {
      enable = true;
      useBabelfish = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    gpu-screen-recorder.enable = true;

    # Storage
    fuse.userAllowOther = true;
  };

  services = {
    # Performance
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    swapspace.enable = true;
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx.rustscheds;
      extraArgs = [
        "--balanced-kworkers" # let kernel handle kworker balancing (>=6.6), avoid conflicting with scx
        "--kthreads-local" # pin per-cpu kthreads to local dsq for lower latency
      ];
    };

    # Peripherals
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = "font-size=21";
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

{ pkgs, ... }:

{
  services = {
    # Performance
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    swapspace.enable = true;
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
      extraArgs = [
        "--autopower"
        "--no-freq-scaling"
      ];
    };

    # Peripherals
    kmscon = {
      enable = true;
      config = {
        hwaccel = true;

        font-size = 21;
        font-name = "IosevkaTerm Nerd Font Mono";

        palette = "custom";
        palette-black = "30,30,46";
        palette-red = "243,139,168";
        palette-green = "166,227,161";
        palette-yellow = "249,226,175";
        palette-blue = "137,180,250";
        palette-magenta = "203,166,247";
        palette-cyan = "148,226,213";
        palette-light-grey = "205,214,244";
        palette-dark-grey = "69,71,90";
        palette-light-red = "243,139,168";
        palette-light-green = "166,227,161";
        palette-light-yellow = "249,226,175";
        palette-light-blue = "137,180,250";
        palette-light-magenta = "203,166,247";
        palette-light-cyan = "148,226,213";
        palette-white = "180,190,254";

        palette-background = "30,30,46";
        palette-foreground = "205,214,244";
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

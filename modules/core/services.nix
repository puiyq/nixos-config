{
  pkgs,
  ...
}:
{
  # Services to start
  services = {
    resolved.enable = true;
    ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
    };
    #onedrive.enable = true;
    fwupd.enable = true;
    userborn.enable = true;
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
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    dbus.implementation = "broker";
    swapspace.enable = true;
    speechd.enable = false;
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs = {
      enable = true; # For Mounting USB & More
      package = pkgs.gvfs;
    };
    openssh.generateHostKeys = true; # generate hostkey without ssh daemon
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx.rustscheds;
    };
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    pipewire = {
      enable = true;
      extraConfig.pipewire = {
        "10-sample-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
          };
        };
        "11-no-upmixing" = {
          "stream.properties" = {
            "channelmix.upmix" = false; # for HDMI audio device that has more than 2 channels
          };
        };
      };
    };
  };

  systemd = {
    oomd.enable = false;
    coredump.extraConfig = ''
      Storage=journal
    '';

    tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];
  };
}

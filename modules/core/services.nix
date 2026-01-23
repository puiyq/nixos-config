{
  pkgs,
  config,
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
    qbittorrent = {
      enable = true;
      package = pkgs.qbittorrent-enhanced-nox;
      serverConfig = {
        LegalNotice.Accepted = true;
        BitTorrent.Session = {
          AddTrackersFromURLEnabled = true;
          AdditionalTrackersURL = "https://ngosang.github.io/trackerslist/trackers_best.txt";
        };
        Preferences = {
          General.Locale = "zh_CN";
          WebUI = {
            Enabled = true;
            Address = "127.0.0.1";
            LocalHostAuth = false;
          };
        };
      };
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
    libinput = {
      enable = true; # Input Handling
      touchpad.disableWhileTyping = true;
    };
    fstrim.enable = true; # SSD Optimizer
    gvfs = {
      enable = true; # For Mounting USB & More
      package = pkgs.gvfs;
    };
    openssh = {
      generateHostKeys = true; # generate hostkey without ssh daemon
      hostKeys = [
        {
          type = "ed25519";
          path = "/etc/ssh/ssh_host_ed25519_key";
        }
      ];
    };
    blueman.enable = false; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx.rustscheds;
    };
    gnome.gnome-keyring.enable = true;
    upower.enable = true;
    tlp = {
      enable = true;
      pd.enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 80;
        SOUND_POWER_SAVE_ON_AC = 10;
        SOUND_POWER_SAVE_ON_BAT = 10;
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      };
    };
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

    mounts = [
      {
        what = "${config.services.qbittorrent.profileDir}/qBittorrent/downloads";
        where = "/home/puiyq/Downloads/qBittorrent";
        type = "none";
        options = "bind,rw";
        wantedBy = [ "multi-user.target" ];
      }
    ];
  };
}

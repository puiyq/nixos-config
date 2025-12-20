{
  pkgs,
  config,
  ...
}:
{
  # Services to start
  services = {
    ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
    };
    #geoipupdate = {
    # enable = true;
    # settings = {
    #   AccountID = 1231707;
    #   DatabaseDirectory = "/var/lib/GeoIP";
    #   LicenseKey = config.age.secrets.maxmind_license_key.path;
    #   EditionIDs = [
    #     "GeoLite2-ASN"
    #     "GeoLite2-City"
    #     "GeoLite2-Country"
    #   ];
    # };
    #};
    #onedrive.enable = true;
    fwupd.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
    };
    beesd.filesystems = {
      "root" = {
        spec = "/";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "5.0"
        ];
      };
    };
    cachix-watch-store = {
      enable = true;
      cacheName = "puiyq";
      cachixTokenFile = config.age.secrets.cachix.path;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos_git;
    };
    dbus = {
      implementation = "broker";
      packages = [ pkgs.gcr_4 ];
    };
    swapspace.enable = true;
    speechd.enable = false;
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    gvfs.enable = true; # For Mounting USB & More
    openssh.enable = false; # Enable SSH
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
    scx = {
      enable = true; # by default uses scx_rustland scheduler
      scheduler = "scx_rusty";
      package = pkgs.scx.rustscheds;
      extraArgs = [
        "--slice-us-underutil"
        "25000"
        "--slice-us-overutil"
        "2500"
        "--interval"
        "1.0"
        "--direct-greedy-under"
        "70"
        "--kick-greedy-under"
        "90"
        "--perf"
        "384"
      ];
    };
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    envfs.enable = false;
    smartd = {
      enable = true;
      notifications = {
        mail = {
          enable = true;
          sender = "puiyongqing@gmail.com";
          recipient = "puiyongqing@gmail.com";
        };
      };
    };
    pipewire = {
      enable = true;
      lowLatency.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  systemd = {
    oomd.enable = false;

    tmpfiles.rules = [
      "w /sys/class/power_supply/BAT0/charge_control_end_threshold - - - - 80"
    ];

    user.services."sshkey-warmup" = {
      wantedBy = [ "default.target" ];
      after = [ "gcr-ssh-agent.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.openssh}/bin/ssh -o BatchMode=yes -T git@github.com
        '';
      };
    };
  };
}

{ pkgs, ... }:

{
  services = {
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

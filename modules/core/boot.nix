{
  pkgs,
  lib,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      # disable startup log
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"

      # remove unused serial tty (no physical interface)
      "8250.nr_uarts=0"

      # zswap
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.zpool=zsmalloc"
      "zswap.max_pool_percent=50"
      "zswap.accept_threshold_percent=90"
      "zswap.shrinker_enabled=1"
    ];

    extraModprobeConfig = ''
      # options kvm_amd nested=1
       options kvm_amd emulate_invalid_guest_state=0 # for slight perf gain
      # options kvm ignore_msrs=1 # for compatibility if crash
    '';

    kernelModules = [
      "kvm-amd"
    ];

    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "kernel.sysrq" = 1; # REISUB
    };

    blacklistedKernelModules = [
      # Obscure network protocols.
      "af_802154" # IEEE 802.15.4
      "appletalk" # Appletalk
      "atm" # ATM
      "ax25" # Amatuer X.25
      "decnet" # DECnet
      "econet" # Econet
      "ipx" # Internetwork Packet Exchange
      "n-hdlc" # High-level Data Link Control
      "netrom" # NetRom
      "p8022" # IEEE 802.3
      "p8023" # Novell raw IEEE 802.3
      "psnap" # SubnetworkAccess Protocol
      "rds" # Reliable Datagram Sockets
      "rose" # ROSE
      "tipc" # Transparent Inter-Process Communication
      "x25" # X.25

      # Old or rare or insufficiently audited filesystems.
      "adfs" # Active Directory Federation Services
      "affs" # Amiga Fast File System
      "befs" # "Be File System"
      "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
      "cramfs" # compressed ROM/RAM file system
      "efs" # Extent File System
      "exofs" # EXtended Object File System
      "freevxfs" # Veritas filesystem driver
      "gfs2" # Global File System 2
      "hfs" # Hierarchical File System (Macintosh)
      "hfsplus" # Same as above, but with extended attributes.
      "hpfs" # High Performance File System (used by OS/2)
      "jffs2" # Journalling Flash File System (v2)
      "jfs" # Journaled File System - only useful for VMWare sessions
      "ksmbd" # SMB3 Kernel Server
      "minix" # minix fs - used by the minix OS
      "nilfs2" # New Implementation of a Log-structured File System
      "omfs" # Optimized MPEG Filesystem
      "qnx4" # Extent-based file system used by the QNX4 OS.
      "qnx6" # Extent-based file system used by the QNX6 OS.
      "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
      "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
      "vivid" # Virtual Video Test Driver (unnecessary)

      # Disable Thunderbolt and FireWire to prevent DMA attacks
      "firewire-core"
      "thunderbolt"
    ];

    initrd = {
      verbose = false;
      systemd.enable = true;
      includeDefaultModules = false;
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        #"thunderbolt"
        "uas"
        "sd_mod"
      ];

      kernelModules = [
        "zstd"
        "zsmalloc"
      ];

      luks.devices.cryptroot = {
        crypttabExtraOpts = [ "tpm2-device=auto" ];
      };
    };

    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
      tmpfsSize = "75%";
      tmpfsHugeMemoryPages = "within_size";
    };

    bcache.enable = false; # useless on mono nvme drive
    kexec.enable = false; # for hot restart kernel (#systemctl kexec)

    loader.limine = {
      enable = true;
      secureBoot.enable = true;
      efiSupport = true;
      maxGenerations = 10;
      style.wallpapers = [ pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath ];
    };

    loader.efi.canTouchEfiVariables = true;
    consoleLogLevel = 3;
    plymouth = {
      enable = true;
      themePackages = [ pkgs.catppuccin-plymouth ];
      theme = lib.mkForce "catppuccin-macchiato";
    };
  };
}

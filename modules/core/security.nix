{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  boot.kernel.sysctl = {
    ##########################
    # TCP / Network Security
    ##########################

    # Ignore bogus ICMP error responses to reduce noise and prevent log flooding attacks
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;

    # Enable reverse path filtering to prevent IP spoofing (strict mode)
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # Disable source routing to prevent attackers from specifying the route packets take
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    # Note: IPv6 uses OR logic between all/interface, so default must also be set explicitly
    "net.ipv6.conf.default.accept_source_route" = 0;

    # Don't send ICMP redirects (we are not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Don't accept ICMP redirects to prevent MITM routing attacks
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    # Refuse even "secure" redirects for stricter security
    "net.ipv4.conf.all.secure_redirects" = 0;
    # IPv6 redirects: must set both all AND default because IPv6 uses OR logic
    # (if either is 1, redirects are accepted — unlike IPv4 which uses AND logic)
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Enable SYN cookies to protect against SYN flood DoS attacks
    "net.ipv4.tcp_syncookies" = 1;

    # Protect against TIME-WAIT assassination hazards (RFC 1337)
    "net.ipv4.tcp_rfc1337" = 1;

    # Hide kernel pointers from all users (including root) to harden against
    # kernel exploitation by making KASLR bypass more difficult
    "kernel.kptr_restrict" = 2;
  };

  imports = [ inputs.run0-pkexec-shim.nixosModules.default ];

  security = {
    rtkit.enable = true;

    protectKernelImage = true;

    run0 = {
      enable = true;
      sudo-shim.enable = true;
      persistentAuth.enable = true;
    };

    account-utils.enable = true;

    sudo.enable = false;

    run0-pkexec-shim.enable = true;

    wrappers = {
      btop = {
        owner = "root";
        group = "root";
        source = lib.getExe pkgs.btop;
        capabilities = "cap_dac_read_search=+ep";
      };

      fusermount3.enable = false;
      fusermount.enable = false;
      gsr-kms-server.enable = false;
      qemu-bridge-helper.enable = false;

      mount.enable = false;
      umount.enable = false;

      su.enable = false;
      sg.enable = false;
      newgrp.enable = false;
    };

    polkit = {
      enable = true;
      extraConfig = ''
        // Allow users to reboot/shutdown without password
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("users") && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )) { return polkit.Result.YES; }
        });

        // Allow users to start/stop beesd without password
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.systemd1.manage-units" &&
              action.lookup("unit") == "beesd@root.service" &&
              (action.lookup("verb") == "start" || action.lookup("verb") == "stop") &&
              subject.isInGroup("users")) {
            return polkit.Result.YES;
          }
        });
      '';
    };
  };

  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = false;
  services.gnome.gcr-ssh-agent.enable = true;
  services.dbus.packages = [ pkgs.gcr_3 ];

  services.oo7.enable = true;
  security.pam.services.greetd.oo7.enable = true;

  # Disable hibernation to prevent memory contents from being written to disk,
  # which could expose encryption keys or other sensitive data.
  # Suspend (RAM-only) is allowed as a usability compromise.
  # Reference: Arch Wiki — Power management/Suspend and hibernate
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "yes";
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
  };
}

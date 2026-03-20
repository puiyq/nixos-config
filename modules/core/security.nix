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

    ################################
    # TCP Performance / Optimizations
    ################################

    # Enable TCP Fast Open for both client (1) and server (2) → 3
    "net.ipv4.tcp_fastopen" = 3;

    # Use BBR congestion control for better throughput and lower latency
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Use CAKE qdisc for intelligent queue management (good for bufferbloat)
    "net.core.default_qdisc" = "cake";

    # Enable TCP window scaling for high-bandwidth connections (RFC 1323)
    "net.ipv4.tcp_window_scaling" = 1;

    # Enable TCP timestamps for accurate RTT measurement (required by BBR and PAWS)
    "net.ipv4.tcp_timestamps" = 1;

    # Enable Selective Acknowledgments for better loss recovery
    "net.ipv4.tcp_sack" = 1;

    # Tune TCP receive buffer advertising (positive = more space for application)
    "net.ipv4.tcp_adv_win_scale" = 1;

    # Reduce TIME_WAIT socket duration from default 60s to 15s
    "net.ipv4.tcp_fin_timeout" = 15;

    # Allow reusing TIME_WAIT sockets for new connections when safe
    "net.ipv4.tcp_tw_reuse" = 1;
  };

  # Load the BBR kernel module (required for tcp_congestion_control = "bbr")
  boot.kernelModules = [ "tcp_bbr" ];

  security = {
    # Enable RealtimeKit for PipeWire / audio services to acquire realtime scheduling
    rtkit.enable = true;

    polkit = {
      enable = true;
      # Allow all members of "users" group to reboot/shutdown without password.
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ( subject.isInGroup("users") && (
           action.id == "org.freedesktop.login1.reboot" ||
           action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
           action.id == "org.freedesktop.login1.power-off" ||
           action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          ))
          { return polkit.Result.YES; }
        })
      '';
    };

    # Auto-unlock GNOME Keyring on login (for SDDM and TTY login)
    pam.services = {
      sddm.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };

    # Use sudo-rs (Rust reimplementation of sudo) for memory safety
    # Only allow users in the wheel group to execute sudo
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

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

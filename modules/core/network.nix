{
  host,
  ...
}:

{
  networking = {
    hostName = host;

    dhcpcd.enable = false;
    modemmanager.enable = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      #wifi.backend = "iwd";
    };

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  services = {
    resolved.enable = true;
    ntpd-rs = {
      enable = true;
      useNetworkingTimeServers = true;
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
  };
}

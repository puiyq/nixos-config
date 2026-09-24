{
  host,
  ...
}:
{
  networking = {
    hostName = host;

    useDHCP = false;
    useNetworkd = host == "roselia";
    modemmanager.enable = false;
    networkmanager = {
      enable = host == "popipa";
      dns = "systemd-resolved";
    };

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  boot.initrd.systemd.network.wait-online.enable = false;
  systemd.network.wait-online.enable = false;

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

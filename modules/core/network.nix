{
  host,
  ...
}:
{
  networking = {
    hostName = "${host}";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}

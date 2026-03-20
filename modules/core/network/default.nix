{
  host,
  config,
  ...
}:
{
  networking = {
    hostName = host;

    dhcpcd.enable = false;
    modemmanager.enable = false;
    networkmanager = {
      enable = true;
      ensureProfiles = import ./nm2nix.nix { inherit config; };
      dns = "systemd-resolved";
      wifi.backend = "iwd";
    };

    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}

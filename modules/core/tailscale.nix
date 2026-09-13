{ config, ... }:
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
  systemd.services.tailscaled.serviceConfig.Environment = [ "TS_DEBUG_FIREWALL_MODE=nftables" ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
  ];
  services = {
    network-manager-applet.enable = true;
    hyprpolkitagent.enable = true;
    #cliphist.enable = true;
  };
}

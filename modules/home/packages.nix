{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start block=yes
    (bilibili-tui.override { withMpv = false; })
    (vivaldi.override { proprietaryCodecs = true; })
    _7zz
    adwaita-icon-theme
    ayugram-desktop
    brightnessctl
    cryptsetup
    curlie
    evtest
    fractal
    gdu # Graphical Disk Usage
    glow
    microfetch
    nautilus
    nix-output-monitor
    nixfmt-rs
    onlyoffice-desktopeditors
    pciutils # Collection Of Tools For Inspecting PCI Devices
    piliplus
    python3
    rage
    remmina
    satty
    sops
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
    zotero
    # keep-sorted end
  ];

  programs = {
    aria2.enable = true;
    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git/"
        ".jj/"
      ];
    };
    jq.enable = true;
    ripgrep.enable = true;
    zapzap.enable = true;
  };
}

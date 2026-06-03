{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start block=yes
    # (bilibili-tui.override { withMpv = false; })
    # bluetui
    # pwvucontrol # For Editing Audio Levels & Devices
    # zotero
    _7zz
    adwaita-icon-theme
    ayugram-desktop
    babelfish # workaround of https://github.com/NixOS/nixpkgs/issues/440098
    brightnessctl
    cage
    cryptsetup
    cura-appimage
    curlie
    evtest
    fractal
    freecad
    gdu # Graphical Disk Usage
    geteduroam
    glow
    grc
    lycosa
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
    virt-viewer
    wget # Tool For Fetching Files With Links
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

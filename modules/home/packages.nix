{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start block=yes
    # (bilibili-tui.override { withMpv = false; })
    # loupe # For Image Viewing
    # zotero
    (vivaldi.override { proprietaryCodecs = true; })
    _7zz
    adwaita-icon-theme
    ayugram-desktop
    babelfish # workaround of https://github.com/NixOS/nixpkgs/issues/440098
    bluetui
    brightnessctl
    cage
    cryptsetup
    curlie
    evtest
    fractal
    gdu # Graphical Disk Usage
    geteduroam
    glow
    grc
    imv
    microfetch
    nautilus
    nix-output-monitor
    nixfmt-rs
    onlyoffice-desktopeditors
    pciutils # Collection Of Tools For Inspecting PCI Devices
    piliplus
    pwvucontrol # For Editing Audio Levels & Devices
    python3
    rage
    remmina
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

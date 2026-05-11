{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start block=yes
    (bilibili-tui.override { withMpv = false; })
    (vivaldi.override { proprietaryCodecs = true; })
    _7zz
    adwaita-icon-theme
    ayugram-desktop
    babelfish # workaround of https://github.com/NixOS/nixpkgs/issues/440098
    brightnessctl
    cage
    cryptsetup
    curlie
    fractal
    gdu # Graphical Disk Usage
    geteduroam
    glow
    grc
    linux-wallpaperengine
    loupe # For Image Viewing
    microfetch
    nautilus
    nix-output-monitor
    nixfmt-rs
    onlyoffice-desktopeditors
    pciutils # Collection Of Tools For Inspecting PCI Devices
    piliplus
    pwvucontrol # For Editing Audio Levels & Devices
    rage
    remmina
    sops
    teams-for-linux
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    virt-viewer
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
    zapzap = {
      enable = true;
      settings = {
        notification.donation_message = true;
        onboarding.completed = true;
        web.scroll_animator = true;
        website.open_page = false;
        performance = {
          in_process_gpu = true;
          single_process = true;
        };
        system = {
          spellCheckers = false;
          theme = "dark";
          wayland = true;
          tray_icon = false;
        };
      };
    };
  };
}

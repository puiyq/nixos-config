{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # keep-sorted start block=yes
    (_7zz.override {
      useUasm = true;
      enableUnfree = true;
    })
    (bilibili-tui.override { withMpv = false; })
    (nixpkgs-review.override {
      withNom = true;
      withDelta = true;
      withGlow = true;
      git = pkgs.gitMinimal;
    })
    (vivaldi.override { proprietaryCodecs = true; })
    adwaita-icon-theme
    ayugram-desktop
    babelfish # workaround of https://github.com/NixOS/nixpkgs/issues/440098
    brightnessctl
    cage
    cryptsetup
    cura-appimage
    curlie
    fractal
    gdu # Graphical Disk Usage
    geteduroam
    glow
    gpu-screen-recorder
    grc
    linux-wallpaperengine
    loupe # For Image Viewing
    microfetch
    nautilus
    nix-output-monitor
    nixfmt
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

    #podman-compose # start group of containers for dev
    #(jetbrains.idea.override { forceWayland = true; })
    #(android-studio.override {
    # forceWayland = true;
    # tiling_wm = true;
    #})
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
        website.open_page = false;
        system = {
          theme = "dark";
          wayland = true;
          tray_icon = false;
        };
      };
    };
  };
}

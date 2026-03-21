{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Desktop Apps
    ayugram-desktop
    fractal
    zapzap # Alternative of Whatsapp
    loupe # For Image Viewing
    nautilus
    pwvucontrol # For Editing Audio Levels & Devices
    (vivaldi.override { proprietaryCodecs = true; })
    #vesktop
    remmina

    # Study
    zotero
    geteduroam
    libreoffice-fresh
    teams-for-linux

    # Media
    gpu-screen-recorder
    piliplus
    (bilibili-tui.override { withMpv = false; })

    # CLI Tools
    brightnessctl
    curlie
    duf # Utility For Viewing Disk Usage In Terminal
    gdu # Graphical Disk Usage
    glow
    microfetch
    nix-output-monitor
    nixfmt
    pciutils # Collection Of Tools For Inspecting PCI Devices
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
    nix-init
    (nixpkgs-review.override {
      withNom = true;
      withDelta = true;
      withGlow = true;
      git = pkgs.gitMinimal;
    })

    # Archive Tools
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    (_7zz.override {
      useUasm = true;
      enableUnfree = true;
    })

    # Security & Encryption
    cryptsetup
    rage
    sops

    # Theming
    adwaita-icon-theme
    grc

    # workaround of https://github.com/NixOS/nixpkgs/issues/440098
    babelfish

    /*
      (prismlauncher.override {
        additionalPrograms = [ ffmpeg ];
        textToSpeechSupport = false;
        jdks = [
          #zulu8
          zulu
          zulu25
        ];
      })
    */
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
  };
}

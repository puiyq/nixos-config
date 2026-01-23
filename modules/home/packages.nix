{ pkgs, ... }:
{
  home.packages = with pkgs; [
    #fractal
    nautilus
    cryptsetup
    adwaita-icon-theme
    gpu-screen-recorder
    virt-viewer # View Virtual Machines
    rage
    sops
    microfetch
    teams-for-linux
    karere # Alternative of Whatsapp
    nix-output-monitor
    onlyoffice-desktopeditors
    loupe # For Image Viewing
    gdu # graphical disk usage
    duf # Utility For Viewing Disk Usage In Terminal
    curlie
    pciutils # Collection Of Tools For Inspecting PCI Devices
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
    pwvucontrol # For Editing Audio Levels & Devices
    glow
    nixfmt
    (jetbrains.idea.override { forceWayland = true; })
    (bilibili-tui.override { withMpv = false; })
    (pkgs.bilibili.override {
      commandLineArgs = "--ozone-platform-hint=wayland --enable-wayland-ime --enable-features=UseOzonePlatform";
    })
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      textToSpeechSupport = false;
      jdks = [
        #zulu8
        zulu
        zulu25
      ];
    })
    #(android-studio.override {
    # forceWayland = true;
    # tiling_wm = true;
    #})
    #animeko
    #podman-compose # start group of containers for dev
  ];
  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../assets/images/wallpapers;
      recursive = true;
    };
    ".face".source = ../../assets/images/face.png;
  };
  programs = {
    jq.enable = true;
    ripgrep.enable = true;
    aria2.enable = true;
    fd = {
      enable = true;
      hidden = true;
      ignores = [
        ".git/"
        ".jj/"
      ];
    };
  };
}

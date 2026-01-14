{
  pkgs,
  inputs,
  ...
}:
{
  programs = {
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    seahorse.enable = true;
    hyprland.enable = true;
    hyprlock.enable = true;
    fuse.userAllowOther = true;
    trippy.enable = true;
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (bilibili-tui.override { withMpv = false; })
    (jetbrains.idea.override { forceWayland = true; })
    #(android-studio.override {
    # forceWayland = true;
    # tiling_wm = true;
    #})
    #openutau
    sbctl
    ruff
    ty
    nixfmt
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
    #animeko
    discord
    xarchiver
    teams-for-linux
    #blender-hip
    (pkgs.bilibili.override {
      commandLineArgs = "--ozone-platform-hint=wayland --enable-wayland-ime --enable-features=UseOzonePlatform";
    })
    cryptsetup
    adwaita-icon-theme
    onlyoffice-desktopeditors
    aria2
    #winetricks
    #wineWowPackages.stagingFull
    (pkgs.element-desktop.override { commandLineArgs = "--password-store=gnome-libsecret"; })
    bottom # btop like util
    brightnessctl # For Screen Brightness Control
    curlie
    duf # Utility For Viewing Disk Usage In Terminal
    eza # Beautiful ls Replacement
    fd
    ffmpeg # Terminal Video / Audio Editing
    gdu # graphical disk usage
    glow
    loupe # For Image Viewing
    jq
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    nix-output-monitor
    #nixpkgs-reviewFull
    pwvucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    ripgrep # Improved Grep
    socat # Needed For Screenshots
    sox # audio support for FFMPEG
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # waypaper # backup wallpaper GUI
    wget # Tool For Fetching Files With Links
    zapzap # Alternative of Whatsapp
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      textToSpeechSupport = false;
      jdks = [
        #zulu8
        zulu
        zulu25
      ];
    })
  ];
}

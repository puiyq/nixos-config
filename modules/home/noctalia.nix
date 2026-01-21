{ pkgs, inputs, ... }:
{
  # import the home manager module
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # configure options
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

    #plugin
    plugins = {
      version = 1;
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        catwalk = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
    };

    pluginSettings = {
      catwalk = {
        minimumThreshold = 25;
        hideBackground = true;
      };
    };

    # main settings
    settings = {
      settingsVersion = 40;

      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = false;
            id = "shortcuts-card";
          }
          {
            enabled = false;
            id = "audio-card";
          }
          {
            enabled = false;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      appLauncher = {
        iconMode = "native";
        enableClipboardHistory = true;
        terminalCommand = "footclient -e";
      };
      audio.cavaFrameRate = 60;
      desktopWidgets.enabled = false;
      sessionMenu = {
        largeButtonsStyle = true;
        showNumberLabels = false;
        powerOptions = [
          {
            action = "lock";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "logout";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "reboot";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "shutdown";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "suspend";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
          {
            action = "hibernate";
            command = "";
            countdownEnabled = true;
            enabled = true;
          }
        ];
      };
      location.name = "Kuching";
      dock.enabled = false;
      general = {
        showScreenCorners = true;
        forceBlackScreenCorners = true;
        telemetryEnabled = false;
        language = "zh-CN";
      };

      #bar
      bar = {
        floating = true;
        density = "spacious";
        hideOnOverview = true;
        outerCorners = false;
        widgets = {
          left = [
            {
              id = "plugin:screen-recorder";
            }
            {
              id = "Spacer";
              width = 20;
            }
            {
              id = "Network";
              displayMode = "onhover";
            }
            {
              id = "Bluetooth";
              displayMode = "onhover";
            }
            {
              id = "Tray";
              blacklist = [ ];
              colorizeIcons = false;
              drawerEnabled = true;
              hidePassive = false;
              pinned = [ ];
            }
            {
              id = "MediaMini";
              compactMode = true;
              compactShowAlbumArt = true;
              compactShowVisualizer = false;
              hideMode = "hidden";
              hideWhenIdle = false;
              maxWidth = 145;
              panelShowAlbumArt = true;
              panelShowVisualizer = true;
              scrollingMode = "always";
              showAlbumArt = true;
              showArtistFirst = true;
              showProgressRing = true;
              showVisualizer = true;
              useFixedWidth = false;
              visualizerType = "linear";
            }
            {
              id = "ActiveWindow";
              colorizeIcons = false;
              hideMode = "hidden";
              maxWidth = 145;
              scrollingMode = "always";
              showIcon = false;
              useFixedWidth = false;
            }
          ];

          center = [
            {
              defaultSettings = {
                hideBackground = false;
                minimumThreshold = 10;
              };
              id = "plugin:catwalk";
            }
            {
              id = "Workspace";
              characterCount = 2;
              colorizeIcons = false;
              enableScrollWheel = true;
              followFocusedScreen = false;
              groupedBorderOpacity = 1;
              hideUnoccupied = true;
              iconScale = 0.8;
              labelMode = "index";
              showApplications = false;
              showLabelsOnlyWhenOccupied = true;
              unfocusedIconsOpacity = 1;
            }
            {
              id = "ControlCenter";
              colorizeDistroLogo = false;
              colorizeSystemIcon = "none";
              customIconPath = "";
              enableColorization = false;
              icon = "noctalia";
              useDistroLogo = false;
            }
          ];

          right = [
            {
              id = "NotificationHistory";
              hideWhenZero = true;
              showUnreadBadge = true;
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
              middleClickCommand = "pwvucontrol || pavucontrol";
            }
            {
              id = "Brightness";
              displayMode = "alwaysShow";
            }
            {
              id = "Spacer";
              width = 20;
            }
            {
              id = "Battery";
              deviceNativePath = "BAT0";
              displayMode = "alwaysShow";
              hideIfNotDetected = true;
              showNoctaliaPerformance = false;
              showPowerProfiles = true;
              warningThreshold = 30;
            }
            {
              id = "Spacer";
              width = 20;
            }
            {
              id = "Clock";
              customFont = "";
              formatHorizontal = "HH:mm ddd, MMM dd";
              formatVertical = "HH mm - dd MM";
              tooltipFormat = "HH:mm ddd, MMM dd";
              useCustomFont = false;
              usePrimaryColor = false;
            }
            {
              id = "SessionMenu";
              colorName = "error";
            }
          ];
        };
      };
    };
  };
}

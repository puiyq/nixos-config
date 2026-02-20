{ lib, ... }:
{
  programs.noctalia-shell.settings.bar = {
    barType = "simple";
    position = "top";
    density = "spacious";
    hideOnOverview = false;
    outerCorners = false;
    useSeparateOpacity = true;
    backgroundOpacity = lib.mkForce 0;
    widgets = {
      left = [
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
          compactMode = false;
          diskPath = "/";
          id = "SystemMonitor";
          showCpuFreq = false;
          showCpuTemp = false;
          showCpuUsage = true;
          showDiskAvailable = false;
          showDiskUsage = false;
          showDiskUsageAsPercent = false;
          showGpuTemp = false;
          showLoadAverage = false;
          showMemoryAsPercent = true;
          showMemoryUsage = true;
          showNetworkStats = true;
          showSwapUsage = false;
          useMonospaceFont = true;
          usePrimaryColor = false;
        }
        {
          id = "MediaMini";
          compactMode = false;
          compactShowAlbumArt = true;
          compactShowVisualizer = true;
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
          visualizerType = "wave";
        }
      ];

      center = [
        {
          id = "Spacer";
          width = 60;
        }
        {
          id = "Workspace";
          characterCount = 2;
          colorizeIcons = false;
          enableScrollWheel = false;
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
          id = "Battery";
          deviceNativePath = "BAT0";
          displayMode = "icon-always";
          hideIfIdle = true;
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
          id = "plugin:weekly-calendar";
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
}

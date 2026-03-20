{
  lib,
  pkgs,
  ...
}:
{
  programs.noctalia-shell.settings = {
    settingsVersion = 53;

    controlCenter = {
      cards = [
        {
          enabled = true;
          id = "profile-card";
        }
        {
          enabled = true;
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
      shortcuts = {
        left = [ { id = "KeepAwake"; } ];
        right = [
          {
            id = "plugin:screen-recorder";
            defaultSettings = {
              audioCodec = "opus";
              audioSource = "default_output";
              colorRange = "limited";
              copyToClipboard = true;
              directory = "";
              filenamePattern = "recording_yyyyMMdd_HHmmss";
              frameRate = "60";
              hideInactive = false;
              quality = "ultra";
              resolution = "original";
              showCursor = true;
              videoCodec = "av1";
              videoSource = "portal";
            };
          }
        ];
      };
    };

    appLauncher = {
      iconMode = "native";
      density = "comfortable";
      enableClipboardHistory = true;
      terminalCommand = "footclient -e";
      enableSettingsSearch = false;
      enableWindowsSearch = false;
      enableSessionSearch = false;
    };

    plugins.autoUpdate = true;

    audio = {
      visualizerType = "wave";
      cavaFrameRate = 60;
    };

    desktopWidgets.enabled = false;

    sessionMenu = {
      largeButtonsStyle = true;
      largeButtonsLayout = "grid";
      showKeybinds = false;
      powerOptions = [
        {
          action = "lock";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "logout";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "suspend";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "shutdown";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "reboot";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "hibernate";
          command = "";
          countdownEnabled = true;
          enabled = true;
          keybind = "";
        }
        {
          action = "rebootToUefi";
          command = "";
          countdownEnabled = true;
          enabled = false;
          keybind = "";
        }
        {
          action = "userspaceReboot";
          command = "";
          countdownEnabled = true;
          enabled = false;
          keybind = "";
        }
      ];
    };

    location.name = "Kuching";
    dock.enabled = false;

    general = {
      showScreenCorners = true;
      enableLockScreenMediaControls = true;
      lockScreenAnimations = true;
      enableShadows = true;
      forceBlackScreenCorners = true;
      telemetryEnabled = false;
      showChangelogOnStartup = false;
      clockStyle = "digital";
      language = "zh-CN";
    };
    idle = {
      enabled = true;
      screenOffTimeout = 0;
      lockTimeout = 720;
      suspendTimeout = 1800;
      fadeDuration = 5;
      customCommands =
        let
          brightnessctl = lib.getExe pkgs.brightnessctl;
        in
        builtins.toJSON [
          {
            name = "turn off keyboard backlight";
            timeout = 180;
            command = "${brightnessctl} --save --device=asus::kbd_backlight set 0";
            resumeCommand = "${brightnessctl} --restore --device=asus::kbd_backlight";
          }
          {
            name = "dim screen";
            timeout = 600;
            command = "${brightnessctl} --save --device=amdgpu_bl1 set 30%";
            resumeCommand = "${brightnessctl} --restore --device=amdgpu_bl1";
          }
        ];
    };
  };
}

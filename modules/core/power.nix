{
  services = {
    upower.enable = true;
    tlp = {
      enable = true;
      pd.enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0;
        STOP_CHARGE_THRESH_BAT0 = 80;
        SOUND_POWER_SAVE_ON_AC = 10;
        SOUND_POWER_SAVE_ON_BAT = 10;
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        USB_EXCLUDE_BTUSB = 1;
      };
    };
  };
}

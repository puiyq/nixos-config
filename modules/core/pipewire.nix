{
  services.pipewire = {
    enable = true;
    extraConfig.pipewire = {
      "10-sample-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
        };
      };
      "11-no-upmixing" = {
        "stream.properties" = {
          "channelmix.upmix" = false; # for HDMI audio device that has more than 2 channels
        };
      };
    };
  };
}

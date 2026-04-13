{
  programs.noctalia-shell =
    let
      pluginSource = "https://github.com/noctalia-dev/noctalia-plugins";
      paloMikuSource = "https://github.com/PaloMiku/PaloMiku-Noctalia-Plugin";

      pluginStates =
        builtins.listToAttrs (
          map
            (name: {
              inherit name;
              value = {
                enabled = true;
                sourceUrl = pluginSource;
              };
            })
            [
              "keybind-cheatsheet"
              "polkit-agent"
              "screen-recorder"
              "weekly-calendar"
            ]
        )
        // {
          "8da3a5:linux-wallpaperengine-controller" = {
            enabled = true;
            sourceUrl = paloMikuSource;
          };
        };
    in
    {
      plugins = {
        version = 2;
        sources = [
          {
            enabled = true;
            name = "Noctalia Plugins";
            url = pluginSource;
          }
          {
            enabled = true;
            name = "PaloMiku-Noctalia-Plugin";
            url = paloMikuSource;
          }
        ];
        states = pluginStates;
      };

      pluginSettings = {
        keybind-cheatsheet = {
          windowWidth = 700;
          columnCount = 1;
        };
      };
    };
}

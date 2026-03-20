{
  programs.noctalia-shell =
    let
      pluginSource = "https://github.com/noctalia-dev/noctalia-plugins";
      pluginStates = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = {
              enabled = true;
              sourceUrl = pluginSource;
            };
          })
          [
            "screen-recorder"
            "keybind-cheatsheet"
            "weekly-calendar"
            "polkit-agent"
          ]
      );
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

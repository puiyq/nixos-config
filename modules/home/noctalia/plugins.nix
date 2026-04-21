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
            "keybind-cheatsheet"
            "polkit-agent"
            "screen-recorder"
            "linux-wallpaperengine-controller"
          ]
      );
    in
    {
      plugins = {
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

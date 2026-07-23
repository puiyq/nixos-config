{
  wayland.windowManager.niri.settings._children = [
    {
      window-rule = {
        draw-border-with-background = false;
        clip-to-geometry = true;
        geometry-corner-radius = 16.0;
      };
    }
    {
      window-rule._children = [
        { match._props.app-id = "^com.rtosta.zapzap$"; }
        { match._props.app-id = "^vivaldi(-stable)?$"; }
        { match._props.app-id = "^org.gnome.Fractal$"; }
        { match._props.app-id = "^com.ayugram.desktop$"; }
        { opacity = 0.95; }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {
            app-id = "^foot(client)?$";
            is-active = true;
          };
        }
        { opacity = 0.85; }
      ];
    }
    {
      window-rule._children = [
        {
          match._props = {
            app-id = "^foot(client)?$";
            is-active = false;
          };
        }
        { opacity = 0.60; }
      ];
    }
    {
      window-rule._children = [
        { match._props.app-id = "^foot(client)?$"; }
        { default-column-width.proportion = 0.5; }
      ];
    }
    {
      window-rule._children = [
        { match._props.title = "^Picture-in-Picture$"; }
        { open-floating = true; }
        { block-out-from = "screencast"; }
      ];
    }
  ];
}

{
  wayland.windowManager.niri.settings = {
    window-rule = [
      {
        draw-border-with-background = false;
        clip-to-geometry = true;
        geometry-corner-radius = 16.0;
      }
      {
        match = [
          { _props.app-id = "^com.rtosta.zapzap$"; }
          { _props.app-id = "^jetbrains-idea$"; }
          { _props.app-id = "^vivaldi(-stable)?$"; }
          { _props.app-id = "^org.gnome.Fractal$"; }
          { _props.app-id = "^com.ayugram.desktop$"; }
          { _props.app-id = "^spotify$"; }
        ];
        opacity = 0.95;
      }
      {
        match = [
          {
            _props.app-id = "^foot(client)?$";
            _props.is-active = true;
          }
        ];
        opacity = 0.85;
      }
      {
        match = [
          {
            _props.app-id = "^foot(client)?$";
            _props.is-active = false;
          }
        ];
        opacity = 0.60;
      }
      {
        match = [
          {
            _props.app-id = "^foot(client)?$";
          }
        ];
        default-column-width.proportion = 0.5;
      }
      {
        match = [
          {
            _props.title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
        block-out-from = "screencast";
      }
    ];
  };
}

{
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [ { namespace = "linux-wallpaperengine"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^noctalia-wallpaper.*"; } ];
        opacity = 0.0;
      }
    ];

    window-rules = [
      {
        draw-border-with-background = false;
        clip-to-geometry = true;
        geometry-corner-radius =
          let
            r = 16.0;
          in
          {
            bottom-left = r;
            bottom-right = r;
            top-left = r;
            top-right = r;
          };
      }
      {
        matches = [
          { app-id = "^com.rtosta.zapzap$"; }
          { app-id = "^jetbrains-idea$"; }
          { app-id = "^vivaldi(-stable)?$"; }
          { app-id = "^org.gnome.Fractal$"; }
          { app-id = "^com.ayugram.desktop$"; }
          { app-id = "^spotify$"; }
        ];
        opacity = 0.95;
      }
      {
        matches = [
          {
            app-id = "^com.mitchellh.ghostty$";
            is-active = true;
          }
          {
            app-id = "^foot(client)?$";
            is-active = true;
          }
        ];
        opacity = 0.85;
      }
      {
        matches = [
          {
            app-id = "^com.mitchellh.ghostty$";
            is-active = false;
          }
          {
            app-id = "^foot(client)?$";
            is-active = false;
          }
        ];
        opacity = 0.60;
      }
      {
        matches = [
          { app-id = "^com.mitchellh.ghostty$"; }
          { app-id = "^foot(client)?$"; }
        ];
        default-column-width.proportion = 0.5;
      }
      {
        matches = [
          { app-id = "^pavucontrol$"; }
          { app-id = "^com.saivert.pwvucontrol$"; }
          { app-id = "^MATLAB"; }
        ];
        excludes = [
          { title = "^MATLAB"; }
        ];
        open-floating = true;
      }
      {
        matches = [ { title = "^Picture-in-Picture$"; } ];
        open-floating = true;
        block-out-from = "screencast";
      }
    ];
  };
}

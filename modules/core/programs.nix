_:

{
  programs = {
    # Shell & Editors
    fish = {
      enable = true;
      useBabelfish = true;
    };
    neovim = {
      enable = false;
      defaultEditor = false;
    };
    gpu-screen-recorder.enable = true;
    bandwhich.enable = true;

    # Storage
    fuse.userAllowOther = true;
  };
}

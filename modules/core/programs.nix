_:

{
  programs = {
    # Shell & Editors
    fish = {
      enable = true;
      useBabelfish = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    gpu-screen-recorder.enable = true;
    bandwhich.enable = true;

    # Storage
    fuse.userAllowOther = true;
  };
}

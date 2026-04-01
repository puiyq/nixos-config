{
  pkgs,
  ...
}:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = [ pkgs.xdg-utils ];

  services.displayManager.sessionPackages = [ pkgs.niri-unstable ];
}

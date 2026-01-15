{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "/home/puiyq/nixos-config";
  };
}

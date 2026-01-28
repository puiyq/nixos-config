{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "/home/kasumi/nixos-config";
  };
}

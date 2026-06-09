{ inputs, ... }:
{
  imports = [
    inputs.angrr.nixosModules.angrr
  ];
  services.angrr = {
    enable = true;
    period = "7d";

    settings.touch.project-globs = [
      "!.git"
      "!.jj"
    ];
  };
  nix.gc.automatic = true;
}

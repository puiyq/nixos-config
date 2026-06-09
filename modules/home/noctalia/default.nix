{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./niri.nix
    ./settings.nix
    ./integrations
  ];
}

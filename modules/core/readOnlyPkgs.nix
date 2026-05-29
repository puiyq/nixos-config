{
  inputs,
  config,
  withSystem,
  ...
}:
{
  imports = [
    inputs.nixpkgs.nixosModules.readOnlyPkgs
  ];

  nixpkgs.pkgs = withSystem config.hardware.facter.report.system ({ pkgs, ... }: pkgs);
}

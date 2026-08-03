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

  nixpkgs.pkgs = withSystem config.hardware.facter.report.system (
    if config.drivers.amdgpu.rocm.enable then ({ rocmPkgs, ... }: rocmPkgs) else ({ pkgs, ... }: pkgs)
  );
  chaotic.nyx.overlay.enable = false;

}

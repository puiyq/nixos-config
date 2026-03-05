{ ... }:
{
  imports = [
    ./disko.nix
    ../../modules/drivers
    ../../modules/core
    ../../secrets
  ];
  # Enable GPU Drivers
  drivers.amdgpu = {
    enable = true;
    #rocm.enable = true;
  };
}

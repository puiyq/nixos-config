{ host, ... }:
{
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
    ../../overlay
    ../../secrets
  ];
  # Enable GPU Drivers
  drivers.amdgpu = {
    enable = true;
    rocm.enable = true;
  };
}

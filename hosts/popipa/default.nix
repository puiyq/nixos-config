{
  imports = [
    # keep-sorted start
    ../../modules/core
    ../../modules/drivers
    ../../secrets
    ./disko.nix
    ./libvirt.nix
    # keep-sorted end
  ];
  # Enable GPU Drivers
  drivers.amdgpu = {
    enable = true;
    # rocm.enable = true;
  };
}

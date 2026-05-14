{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.drivers.amdgpu;
  rocmEnv = pkgs.symlinkJoin {
    name = "rocm-combined";
    paths = with pkgs.rocmPackages; [
      rocblas
      hipblas
      clr
      amdsmi
      #hiprt
      #rocfft
      #hipcc
      #rocrand
      #hipsparse
      #half
      #hsakmt
    ];
  };
in
{
  options.drivers.amdgpu = {
    enable = lib.mkEnableOption "AMD GPU drivers";
  };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.rules = lib.mkIf config.nixpkgs.config.rocmSupport [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

    environment = lib.mkIf config.nixpkgs.config.rocmSupport {
      systemPackages = [ rocmEnv ];
    };
  };
}

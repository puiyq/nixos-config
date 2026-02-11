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
      #amdsmi
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
    rocm.enable = lib.mkEnableOption "ROCm support";
  };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.rules = lib.mkIf cfg.rocm.enable [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];

    nixpkgs.config = lib.mkIf cfg.rocm.enable { rocmSupport = true; };

    environment = lib.mkIf cfg.rocm.enable {
      systemPackages = [ rocmEnv ];
      variables.HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    };
  };
}

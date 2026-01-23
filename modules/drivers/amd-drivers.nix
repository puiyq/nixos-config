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
    enable = lib.mkEnableOption "Enable AMD Drivers";
    rocm.enable = lib.mkEnableOption "Enable ROCM";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      hardware.amdgpu.opencl.enable = true;
    })

    (lib.mkIf cfg.rocm.enable {
      systemd.tmpfiles.rules = [ "L+    /opt/rocm   -    -    -     -    ${rocmEnv}" ];

      nixpkgs.config.rocmSupport = true;

      environment = {
        systemPackages = [ rocmEnv ];
        variables.HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      };
    })
  ];
}

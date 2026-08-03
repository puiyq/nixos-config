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
    rocm.enable = lib.mkEnableOption "ROCm support for AMD GPU drivers";
  };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu.opencl.enable = true;

    systemd.tmpfiles.settings = lib.mkIf cfg.rocm.enable {
      "10-amdgpu-rocm" = {
        "/opt/rocm"."L+".argument = "${rocmEnv}";
        "/opt/amdgpu/share/libdrm/amdgpu.ids"."L+".argument = "${pkgs.libdrm}/share/libdrm/amdgpu.ids";
      };
    };

    environment = lib.mkIf cfg.rocm.enable {
      systemPackages = [ rocmEnv ];
    };
  };
}

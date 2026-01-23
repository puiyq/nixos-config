{
  pkgs,
  config,
  lib,
  ...
}:
{
  services = {
    open-webui.enable = true;
    ollama = {
      enable = true;
    }
    // lib.optionalAttrs config.rocmSupport {
      package = pkgs.ollama-rocm;
      rocmOverrideGfx = "11.0.0";
    };
  };
  boot.kernelModules = [ "amdgpu" ]; # workaround of race condition (see issue #422355 on nixpkgs)
}

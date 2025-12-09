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
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.0";
    };
  };
  boot.kernelModules = (lib.mkIf config.services.ollama.acceleration == "rocm" || "vulkan") [
    "amdgpu"
  ]; # workaround of race condition (see issue #422355 on nixpkgs)
}

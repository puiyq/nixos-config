{
  pkgs,
  config,
  ...
}:
{
  services = {
    open-webui.enable = true;
    ollama = {
      enable = true;
      package = if config.drivers.amdgpu.rocm.enable then pkgs.ollama-rocm else pkgs.ollama-vulkan;
      rocmOverrideGfx = if config.drivers.amdgpu.rocm.enable then "11.0.0" else null;
    };
  };
  boot.kernelModules = [ "amdgpu" ]; # workaround of race condition (see issue #422355 on nixpkgs)
}

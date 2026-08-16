{
  pkgs,
  config,
  ...
}:
{
  services = {
    open-webui = {
      enable = true;
      port = 11111;
    };
    ollama = {
      enable = true;
      package = if config.drivers.amdgpu.rocm.enable then pkgs.ollama-rocm else pkgs.ollama-vulkan;
    };
  };
}

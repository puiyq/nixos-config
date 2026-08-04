{
  username,
  ...
}:
{
  specialisation.passthrough = {
    inheritParentConfig = true;

    configuration = {
      system.nixos.label = "passthrough";

      home-manager.users.${username}.wayland.windowManager.niri.settings = {
        _children = [
          {
            output = {
              _args = [ "DP-1" ];
              scale = 1.0;
              mode = "2560x1440@59.951";
              position._props = {
                x = 0;
                y = 0;
              };
            };
          }
        ];
      };

      boot = {
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
        kernelParams = [
          "amd_iommu=on"
          "vfio-pci.ids=1002:7590,1002:ab40"
        ];
      };
    };
  };
}

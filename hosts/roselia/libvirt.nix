{ inputs, mkWin11Domain, ... }:

{
  imports = [ ../../modules/core/libvirt-base.nix ];

  virtualisation.libvirt.connections."qemu:///system" = {
    networks = [
      {
        active = true;
        definition = inputs.nixvirt.lib.network.writeXML (
          inputs.nixvirt.lib.network.templates.bridge {
            uuid = "6bbe6459-51b6-4fa8-849e-eb0179523243";
            subnet_byte = 122;
          }
        );
      }
    ];
    pools = [
      {
        active = true;
        definition = inputs.nixvirt.lib.pool.writeXML {
          name = "default";
          uuid = "a1b2c3d4-e5f6-7890-abcd-ef1234567890";
          type = "dir";
          target = {
            path = "/var/lib/libvirt/images";
          };
        };
      }
    ];
    domains = [
      {
        active = false;
        restart = null;
        definition = mkWin11Domain {
          memoryGiB = 8;
          vcpuCount = 12;
          topologyCores = 6;

          emulatorpinCpuset = "0,8,1,9";

          vcpupin = [
            {
              vcpu = 0;
              cpuset = "2";
            }
            {
              vcpu = 1;
              cpuset = "10";
            }
            {
              vcpu = 2;
              cpuset = "3";
            }
            {
              vcpu = 3;
              cpuset = "11";
            }
            {
              vcpu = 4;
              cpuset = "4";
            }
            {
              vcpu = 5;
              cpuset = "12";
            }
            {
              vcpu = 6;
              cpuset = "5";
            }
            {
              vcpu = 7;
              cpuset = "13";
            }
            {
              vcpu = 8;
              cpuset = "6";
            }
            {
              vcpu = 9;
              cpuset = "14";
            }
            {
              vcpu = 10;
              cpuset = "7";
            }
            {
              vcpu = 11;
              cpuset = "15";
            }
          ];

          hostdevs = [
            {
              mode = "subsystem";
              type = "pci";
              managed = true;
              source = {
                address = {
                  domain = 0;
                  bus = 3;
                  slot = 0;
                  function = 0;
                };
              };
            }
            {
              mode = "subsystem";
              type = "pci";
              managed = true;
              source = {
                address = {
                  domain = 0;
                  bus = 3;
                  slot = 0;
                  function = 1;
                };
              };
            }
            {
              mode = "subsystem";
              type = "pci";
              managed = true;
              source = {
                address = {
                  domain = 0;
                  bus = 19;
                  slot = 0;
                  function = 0;
                };
              };
            }
            {
              mode = "subsystem";
              type = "usb";
              managed = true;
              source = {
                vendor.id = 4817;
                product.id = 4305;
              };
            }
          ];

          shmDevices = [
            {
              name = "kvmfr";
              size = {
                unit = "M";
                count = 64;
              };
              model = {
                type = "ivshmem-plain";
              };
            }
          ];
        };
      }
    ];
  };
}

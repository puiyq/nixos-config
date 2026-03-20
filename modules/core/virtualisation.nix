{
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.nixvirt.nixosModules.default ];

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  virtualisation = {
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      #defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      autoPrune.enable = true;
    };
    libvirt = {
      enable = true;
      swtpm.enable = true;
      connections."qemu:///system" = {
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

            definition = inputs.nixvirt.lib.domain.writeXML (
              let
                base = inputs.nixvirt.lib.domain.templates.windows {
                  name = "win11";
                  uuid = "faa13f7f-09df-4eea-a773-4fecc4b4bd04";

                  memory = {
                    count = 8;
                    unit = "GiB";
                  };

                  vcpu = {
                    count = 8;
                  };

                  storage_vol = {
                    pool = "default";
                    volume = "win11.qcow2";
                  };

                  install_vol = "/home/${username}/Downloads/tiny11 25h2 26200.iso";
                  nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";

                  virtio_net = true;
                  virtio_drive = true;
                  virtio_video = true;
                  install_virtio = true;
                };
              in
              base
              // {
                cpu = {
                  mode = "host-passthrough";
                  topology = {
                    sockets = 1;
                    cores = 4;
                    threads = 2;
                  };
                  feature = [
                    {
                      name = "topoext";
                      policy = "require";
                    }
                  ];
                };

                features = base.features // {
                  hyperv = base.features.hyperv // {
                    vendor_id = {
                      state = true;
                      value = "randomid";
                    };
                  };
                };

                cputune = {
                  emulatorpin = {
                    cpuset = "0-1,8-9";
                  };
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
                  ];
                };

                memoryBacking = {
                  locked = { };
                };

                devices = base.devices // {
                  channel = base.devices.channel ++ [
                    {
                      type = "unix";
                      target = {
                        type = "virtio";
                        name = "org.qemu.guest_agent.0";
                      };
                    }
                  ];
                };
              }
            );
          }
        ];
      };
    };
  };
  programs.virt-manager.enable = true;
  networking = {
    nat = {
      enable = true;
      internalInterfaces = [ "virbr0" ];
    };
    firewall.interfaces = {
      virbr0 = {
        allowedUDPPorts = [
          # DNS
          53
          # DHCP
          67
        ];
      };
    };
  };
}

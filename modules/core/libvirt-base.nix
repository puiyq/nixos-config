{
  inputs,
  username,
  ...
}:

let
  mkWin11Domain =
    {
      memoryGiB,
      vcpuCount,
      topologyCores,
      topologyThreads ? 2,
      vcpupin,
      emulatorpinCpuset,
      hostdevs ? [ ],
      shmDevices ? [ ],
    }:
    inputs.nixvirt.lib.domain.writeXML (
      let
        base = inputs.nixvirt.lib.domain.templates.windows {
          name = "win11";
          uuid = "faa13f7f-09df-4eea-a773-4fecc4b4bd04";

          memory = {
            count = memoryGiB;
            unit = "GiB";
          };

          vcpu = {
            count = vcpuCount;
          };

          storage_vol = {
            pool = "default";
            volume = "win11.img";
          };

          install_vol = "/home/${username}/Downloads/tiny11 25h2 26200.iso";
          nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";

          virtio_net = true;
          virtio_drive = true;
          virtio_video = false;
          install_virtio = true;
        };
      in
      base
      // {
        cpu = {
          mode = "host-passthrough";
          topology = {
            sockets = 1;
            cores = topologyCores;
            threads = topologyThreads;
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
            cpuset = emulatorpinCpuset;
          };
          inherit vcpupin;
        };

        memoryBacking = {
          locked = { };
        };

        devices = base.devices // {
          disk = [
            {
              type = "file";
              device = "disk";
              driver = {
                name = "qemu";
                type = "raw";
                cache = "none";
                io = "native";
                discard = "unmap";
              };
              source = {
                file = "/var/lib/libvirt/images/win11.img";
              };
              target = {
                dev = "vda";
                bus = "virtio";
              };
            }
          ]
          ++ (builtins.tail base.devices.disk);

          channel = base.devices.channel ++ [
            {
              type = "unix";
              target = {
                type = "virtio";
                name = "org.qemu.guest_agent.0";
              };
            }
          ];

          hostdev = (base.devices.hostdev or [ ]) ++ hostdevs;
          shmem = (base.devices.shmem or [ ]) ++ shmDevices;
        };
      }
    );
in
{
  imports = [ inputs.nixvirt.nixosModules.default ];

  systemd.tmpfiles.rules = [ "h /var/lib/libvirt/images +C - - - -" ];
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  virtualisation = {
    spiceUSBRedirection.enable = true;
    podman = {
      enable = false;
      dockerCompat = true;
      autoPrune.enable = true;
    };
    libvirt = {
      enable = true;
      swtpm.enable = true;
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
          53
          67
        ];
      };
    };
  };

  _module.args.mkWin11Domain = mkWin11Domain;
}

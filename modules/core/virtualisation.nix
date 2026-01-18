{ pkgs, inputs, ... }:
{
  imports = [ inputs.nixvirt.nixosModules.default ];

  # Only enable either docker or podman -- Not both
  virtualisation = {
    /*
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
        qemu.swtpm.enable = true;
      };
    */
    spiceUSBRedirection.enable = true;
    docker.enable = false;
    podman = {
      enable = true;
      dockerCompat = true;
      #defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      autoPrune.enable = true;
    };
    #waydroid.enable = true;
    libvirt = {
      enable = true;
      package = pkgs.libvirt.override {
        enableXen = false;
        enableZfs = false;
      };
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
              inputs.nixvirt.lib.domain.templates.windows {
                name = "win11";
                uuid = "faa13f7f-09df-4eea-a773-4fecc4b4bd04";

                memory = {
                  count = 8;
                  unit = "GiB";
                };

                vcpu = {
                  count = 4;
                };

                storage_vol = {
                  pool = "default";
                  volume = "win11.qcow2";
                };

                install_vol = "/home/puiyq/Downloads/tiny11 25h2 26200.iso";

                nvram_path = "/var/lib/libvirt/qemu/nvram/win11_VARS.fd";

                virtio_net = true;
                virtio_drive = true;
                virtio_video = true;
                install_virtio = true;
              }
            );
          }
        ];
      };
    };

  };
  programs.virt-manager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    #podman-compose # start group of containers for dev
    #nur.repos.ataraxiasjel.waydroid-script
    #waydroid-helper
  ];
}

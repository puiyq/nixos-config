{
  inputs,
  pkgs,
  lib,
  username,
  ...
}:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter.enable = true;

  services.greetd.settings.default_session.user = username;

  services.displayManager.sessionPackages =
    let
      mkSession =
        id: name: text:
        lib.extendDerivation true { providedSessions = [ id ]; } (
          pkgs.writeTextDir "share/wayland-sessions/${id}.desktop" ''
            [Desktop Entry]
            Name=${name}
            Exec=${
              lib.getExe (
                pkgs.writeShellApplication {
                  runtimeInputs = with pkgs; [
                    virt-viewer
                    cage
                  ];
                  name = id;
                  inherit text;
                }
              )
            }
            Type=Application
          ''
        );
    in
    [
      (mkSession "windows-vm" "Windows VM" ''
        VM_NAME=win11

        vm_is_running() {
          virsh domstate "$VM_NAME" 2>/dev/null | grep -q "^running"
        }

        cleanup() {
          if vm_is_running; then
            virsh shutdown "$VM_NAME"
          fi
          systemctl start beesd@root
        }
        trap cleanup EXIT

        systemctl stop beesd@root

        if ! vm_is_running; then
          virsh start "$VM_NAME"
        fi

        cage -- virt-viewer --attach --connect qemu:///system "$VM_NAME"
      '')
    ];
}

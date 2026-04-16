{ pkgs, lib, ... }:
{
  services.displayManager.ly = {
    enable = true;
    x11Support = false;
    settings = {
      animation = "matrix";
      bigclock = "en";
      default_input = "password";
      clear_password = true;
      custom_sessions =
        let
          mkSession =
            id: name: exec:
            pkgs.writeTextDir "${id}.desktop" ''
              [Desktop Entry]
              Name=${name}
              Exec=${exec}
              Type=Application
            '';

          startVM = pkgs.writeShellApplication {
            name = "windows-vm";
            text = ''
              systemctl stop beesd@root
              if ! virsh domstate win11 | grep -q "running"; then
                virsh start win11
              fi
              cage -- virt-viewer --attach --connect qemu:///system win11
              if ! virsh domstate win11 | grep -q "shut off"; then
                virsh shutdown win11
              fi
              systemctl start beesd@root
            '';
          };
        in
        "${mkSession "windows-vm" "Windows VM" (lib.getExe startVM)}";
      hide_version_string = true;
      hide_keyboard_locks = true;
      hide_key_hints = true;
      session_log = null;
      xsessions = null;
      xinitrc = null;
      setup_cmd = "";
    };
  };
}

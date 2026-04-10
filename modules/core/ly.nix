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
          startVM = pkgs.writeShellApplication {
            name = "windows-vm";
            runtimeInputs = with pkgs; [
              cage
              libvirt
              virt-viewer
            ];
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
        "${pkgs.writeTextDir "windows-vm.desktop" ''
          [Desktop Entry]
          Name=Windows VM
          Exec=${lib.getExe startVM}
          Type=Application
        ''}";
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

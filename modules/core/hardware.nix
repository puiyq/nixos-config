{
  hardware = {
    facter.reportPath = ../../facter.json;
    enableRedistributableFirmware = true;
    bluetooth.powerOnBoot = true;
    cpu.amd.updateMicrocode = true;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
  services.udev.extraRules = ''
    # Aula Hero 84 HE - WebUSB & WebHID
    SUBSYSTEM=="usb", ATTRS{idVendor}=="372e", ATTRS{idProduct}=="103e", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="372e", ATTRS{idProduct}=="103e", MODE="0666", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="372e", ATTRS{idProduct}=="103e", MODE="0666", TAG+="uaccess"
  '';
}

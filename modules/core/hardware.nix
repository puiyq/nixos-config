{ pkgs, ... }:
{
  hardware = {
    facter.reportPath = ../../facter.json;
    enableRedistributableFirmware = true;
    bluetooth.powerOnBoot = true;
    cpu.amd.updateMicrocode = true;
    block.defaultScheduler = "adios";
  };
  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };
  services.udev.extraRules = ''
    # Aula Hero 84 HE - WebHID
    KERNEL=="hidraw*", ATTRS{idVendor}=="372e", ATTRS{idProduct}=="103e", MODE="0660", GROUP="users", TAG+="uaccess"
  '';
}

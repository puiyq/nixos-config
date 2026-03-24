{
  services = {
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = "font-size=21";
    };
    speechd.enable = false;
    fwupd.enable = true;
    libinput = {
      enable = true; # Input Handling
      touchpad.disableWhileTyping = true;
    };
  };
}

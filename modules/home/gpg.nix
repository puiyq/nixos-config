{
  programs.gpg = {
    enable = false;
    settings = {
      s2k-mode = "3";
      s2k-count = "65011712";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
    };
    publicKeys = [
      {
        source = "/home/puiyq/puiyq-gpg-keys.pub";
        trust = 5;
      } # ultimate trust, my own keys
    ];
  };
}

{inputs, ...}: {
  kosei = {
    boot.enable = true;
    displayManager.enable = true;
    ssh.enable = true;
    yubikey.enable = true;
  };
}

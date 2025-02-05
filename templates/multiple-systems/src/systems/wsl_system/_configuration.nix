{lib, ...}: {
  kosei = {
    audio.enable = false;
    boot.enable = false;
    displayManager.enable = false;
    RGB.enable = false;
    virtualization.wsl.enable = true;
    wsl.enable = true;
  };

  environment.etc."resolv.conf".source = lib.mkForce /etc/resolv.conf;
}

_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.support.guest.qemu;
in {
  options = {
    frostbite.support.guest.qemu = {
      enable = lib.mkEnableOption "QEMU guest suppport";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };
  };
}

scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.qemuGuest;
in {
  options = {
    kosei.qemuGuest = {
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

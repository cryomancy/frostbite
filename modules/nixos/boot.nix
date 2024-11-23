{
  config,
  lib,
  ...
}: let
  cfg = config.fuyuBoot;
in {
  options.fuyuBoot.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
      };
    };
  };
}

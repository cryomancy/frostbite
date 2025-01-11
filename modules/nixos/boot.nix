scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.boot;
in {
  options.kosei.boot.enable = lib.mkOption {
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

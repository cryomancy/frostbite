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
    boot = {
      initrd.systemd.enable = true;
      loader = {
        grub = lib.mkDefault {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
          useOSProber = true;
        };
      };
    };
  };
}

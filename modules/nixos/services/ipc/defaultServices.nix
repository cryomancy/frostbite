scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.defaultServices;
in {
  options = {
    kosei.defaultServices = {
      enable = lib.mkEnableOption "defaultServices";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      dbus.enable = true;
      earlyoom = {
        enable = true;
        enableNotifications = true;
      };
      gvfs.enable = true;
      tumbler.enable = true;
    };
  };
}

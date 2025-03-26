_: {
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
      earlyoom = {
        enable = true;
        enableNotifications = true;
      };
      gvfs.enable = true;
      tumbler.enable = true;
    };
  };
}

_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.defaults;
in {
  options = {
    frostbite.services.defaults = {
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

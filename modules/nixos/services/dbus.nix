scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.dbus;
in {
  options = {
    kosei.dbus = {
      enable = lib.mkEnableOption "dbus";
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus = {
      packages = [pkgs.gcr_4];
    };
  };
}

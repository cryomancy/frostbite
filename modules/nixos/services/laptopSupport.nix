scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.laptopSupport;
in {
  options = {
    kosei.laptopSupport = {
      enable = lib.mkEnableOption "laptop suppport";
      enableHyprlandSupport = lib.mkEnableOption "laptop Hyprland support";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      logind = {
        lidSwitch = "suspend";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      };
      geoclue2 = {
        enable = true;
      };
    };

    hardware.sensor.iio.enable = true;

    programs.iio-hyprland.enable = lib.mkIf cfg.enableHyprlandSupport true;
  };
}

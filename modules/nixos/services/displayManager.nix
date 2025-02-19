scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.displayManager;
in {
  options.kosei = {
    displayManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      gdm.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      lightdm.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      tuigreet.enable = lib.mkOption {
        type = lib.types.bool;
        default = cfg.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf cfg.tuigreet.enable [
      pkgs.greetd.tuigreet
    ];

    services.greetd = lib.mkIf cfg.tuigreet.enable {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command =
            if config.kosei.GNOME.enable
            then "${pkgs.greet.tuigreet}/bin/tuigreet --time --cmd dbus-run-session gnome-session"
            else "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    services.xserver.displayManager = {
      lightdm.enable = lib.mkIf cfg.lightdm.enable true;
      gdm.enable = lib.mkIf cfg.gdm.enable true;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuDM;
in {
  options = {
    fuyuDM = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      tuigreet.enable = lib.mkEnableOption "tuigreet";
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  };
}

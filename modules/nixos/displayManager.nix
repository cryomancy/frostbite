{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.displayManager;
in {
  options = {
    displayManager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      option = {
        type = lib.types.enum ["lightgreet" "tuigreet" "gdm"];
        default = "tuigreet";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf cfg.tuigreet.enable [
      pkgs.greetd.tuigreet
    ];

    services.greetd = lib.mkIf (cfg.option == "tuigreet") {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    displayManager.lightdm.enable = lib.mkIf (cfg.option == "lightdm") true;
    services.xserver.displayManager.gdm.enable = lib.mkIf (cfg.option == "gdm") true;
  };
}

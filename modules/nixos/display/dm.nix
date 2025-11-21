_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.dm;
in
{
  options = {
    frostbite.display.dm = lib.mkOption {
      type = lib.types.enum [
        "greetd"
        "tuigreet"
        "lightdm"
        "gdm"
      ];
      default = "tuigreet";
      description = ''
           The display manager service that is enabled by default.
        If no value is selected then tuigreet is selected by default.
      '';
    };
  };

  config = {
    environment.systemPackages = lib.mkIf (cfg == "tuigreet") [
      pkgs.greetd.tuigreet
    ];

    services.greetd = lib.mkIf (cfg == "tuigreet") {
      enable = true;
      #vt = 2;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    services.xserver.displayManager = {
      lightdm.enable = lib.mkIf (cfg == "lightdm") true;
      gdm.enable = lib.mkIf (cfg == "gdm") true;
    };
  };
}

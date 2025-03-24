_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.displayManager;
in {
  options.kosei = {
    displayManager = lib.mkOption {
	  type = lib.types.enum ["greetd" "tuigreet" "lightdm" "gdm"];
	  default = "tuigreet";
	  description = ''
	    The display manager service that is enabled by default.
		If no value is selected then tuigreet is selected by default.
	  '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkIf (cfg == "tuigreet") [
      pkgs.greetd.tuigreet
    ];

    services.greetd = lib.mkIf (cfg == "tuigreet") {
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
      lightdm.enable = lib.mkIf (cfg == "lightdm") true;
      gdm.enable = lib.mkIf (cfg == "gdm") true;
    };
  };
}

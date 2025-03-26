_: {
  config,
  pkgs,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.programs.arduino;
in {
  options = {
    frostbite.programs.arduino.enable = lib.mkEnableOption "arduino";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        arduino-cli
        arduino-ide
        digital
        simulide
      ];

      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [
            ".config/arduino-ide"
            ".config/Arduino-ide"
          ];
        };
      };
    };

    #xdg.configFile."arudino-ide/settings.json".text = builtins.toJSON {
    #  enableMenu = false;
    #};
  };
}

_: {
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.frostbite.programs.libreoffice;
in {
  options = {
    frostbite.programs.libreoffice = {
      enable = lib.mkEnableOption "frostbite home packages";
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [".config/arduino-ide"];
        };
      };

      packages = with pkgs; [
        libreoffice-qt6
      ];
    };
  };
}

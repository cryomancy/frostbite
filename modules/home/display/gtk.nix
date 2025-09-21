_: {
  config,
  lib,
  user,
  pkgs,
  ...
}: let
  cfg = config.frostbite.display.gtk;
in {
  options = {
    frostbite.display.gtk = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}

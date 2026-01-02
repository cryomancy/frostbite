_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.utils.display;
in
{
  options = {
    frostbite.utils.display = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nwg-displays
    ];
  };
}

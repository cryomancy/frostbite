_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.hyprland;
in
{
  options = {
    frostbite.display.hyprland = lib.mkOption {
      type = lib.types.boolean;
      default = true;
    };
  };

  config = {
    programs.hyprland = {
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      enable = true;
      withUWSM = true;
    };
  };
}

_:
{
  config,
  lib,
  pkgs,
  inputs,
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
      package = inputs.hyde-nixpkgs.legacyPackages.x86_64-linux.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      enable = true;
      withUWSM = true;
    };
  };
}

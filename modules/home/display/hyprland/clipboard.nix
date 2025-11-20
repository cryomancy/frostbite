_:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.frostbite.display.hyprland.clipboard;
in
{
  options = {
    frostbite.display.hyprland.clipboard = {
      enable = lib.mkOption {
        type = lib.types.bool;
        # default = config.frostbite.display.hyprland.enable;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      clipman # simple clipboard manager for Wayland
    ];
    services.cliphist = {
      allowImages = true;
      enable = true;
    };
  };
}

scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.cliphist;
in {
  options = {
    kosei.cliphist = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.kosei.hyprland.enable;
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

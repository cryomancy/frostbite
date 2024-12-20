{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.rofi;
in {
  options = {
    fuyuNoKosei.rofi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.fuyuNoKosei.compositor.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland-unwrapped;
      extraConfig = {
        show-icons = true;
        image_size = 48;
        columns = 3;
        allow_images = true;
        insensitive = true;
        run-always_parse_args = true;
        run-cache_file = "/dev/null";
        run-exec_search = true;
        matching = "multi-contains";
      };
    };
  };
}

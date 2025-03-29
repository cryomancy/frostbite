_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.gaming.gamemode;
in {
  options = {
    frostbite.gaming.gamemode = {
      enable = lib.mkEnableOption "gamemode";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
          gpu = {
            apply_gpu_optimizations = "accept-responsibility";
            gpu_device = 0;
          };
        };
      };
    };
  };
}

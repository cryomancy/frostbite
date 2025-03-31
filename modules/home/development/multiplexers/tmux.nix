_: {
  lib,
  config,
  ...
}: let
  cfg = config.frostbite.multiplexers.tmux;
in {
  options = {
    frostbite.multiplexers.tmux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
    };
  };
}

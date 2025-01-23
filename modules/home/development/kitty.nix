scoped: {
  lib,
  config,
  ...
}: let
  cfg = config.kosei.kitty;
in {
  options = {
    kosei.kitty.enable = lib.mkOptionDefault "kitty";
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}

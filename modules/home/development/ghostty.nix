scoped: {
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kosei.ghostty;
in {
  options = {
    kosei.ghostty.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ghostty];
  };
}

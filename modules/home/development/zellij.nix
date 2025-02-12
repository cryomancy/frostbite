scoped: {
  lib,
  config,
  ...
}: let
  cfg = config.kosei.zellij;
in {
  options = {
    kosei.zellij.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}

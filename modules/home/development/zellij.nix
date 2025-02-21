scoped: {
  lib,
  config,
  user,
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
    home.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [".config/zellij"];
      };
    };
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}

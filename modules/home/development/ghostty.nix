scoped: {
  lib,
  config,
  pkgs,
  user,
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
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      installBatSyntax = true;
    };
    home.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [".config/ghostty"];
      };
    };
  };
}

_: {
  lib,
  config,
  user,
  ...
}: let
  cfg = config.frostbite.terminals.ghostty;
in {
  options = {
    frostbite.terminals.ghostty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      installBatSyntax = true;
    };
    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [".config/ghostty"];
      };
    };
  };
}

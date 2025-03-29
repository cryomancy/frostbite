_: {
  lib,
  config,
  user,
  ...
}: let
  cfg = config.frostbite.multiplexers.zellij;
in {
  options = {
    frostbite.multiplexers.zellij = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.impermanence.enable {
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

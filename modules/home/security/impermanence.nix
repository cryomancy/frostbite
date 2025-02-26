scoped: {
  config,
  inputs,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.homeManagerModules.impermanence];

  options = {
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    home.persistence = {
      inherit (cfg) enable;
      "/persist/${user}" = {
        allowOther = true;

        directories = [
        ];

        files = [
          ".bash_history"
        ];
      };
    };
  };
}

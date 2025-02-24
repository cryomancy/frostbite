scoped: {
  config,
  inputs,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  options = {
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config = lib.mkIf cfg.enable {
    imports = [inputs.impermanence.homeManagerModules.impermanence];

    home.persistence = {
      "/nix/persistent/home/${user}" = {
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

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

  config = {
    home.persistence =
      if !cfg.enable
      then {}
      else {
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

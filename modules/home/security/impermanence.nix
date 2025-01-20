scoped: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.kosei.impermanence;
in {
  imports = [inputs.impermanence.homeManagerModules.impermanence];

  options = {
    kosei.impermanence.enable = lib.mkEnableOption "impermanence";
  };

  config =
    lib.mkIf cfg.enable {
    };
}

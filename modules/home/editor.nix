scoped: {
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kosei.editor;
in {
  options = {
    kosei.editor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      defaultEditor = lib.mkOption {
        type = lib.types.package;
        default = pkgs.fuyuvim;
        example = pkgs.jeezyvim;
      };
    };
  };

  imports = [
    inputs.fuyuvim.overlays.default
    inputs.fuyuvim.packages.fuyuvim
  ];

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.defaultEditor];
  };
}

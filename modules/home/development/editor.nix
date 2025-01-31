scoped: {
  config,
  inputs,
  pkgs,
  lib,
  system,
  ...
}: let
  cfg = config.kosei.editor;
  inherit (inputs.fuyuvim.packages.${system}) fuyuvim;
in {
  options = {
    kosei.editor = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      defaultEditor = lib.mkOption {
        type = lib.types.package;
        default = fuyuvim;
        example = pkgs.emacs;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.defaultEditor];
  };
}

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
        example = pkgs.emacs;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    pkgs = pkgs.appendOverlays [inputs.fuyuvim.overlays.default];
    home.packages = [cfg.defaultEditor];
  };
}

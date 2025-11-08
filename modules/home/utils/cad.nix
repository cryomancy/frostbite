_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.utils.cad;
in {
  options = {
    frostbite.utils.cad = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      openscad # The Programmers Solid 3D CAD Modeller
      librecad # 2D CAD drawing tool based on the community edition of QCad
      solvespace # Parametric 2D/3D CAD
    ];
  };
}

scoped: {
  config,
  pkgs,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.doom-emacs;
in {
  options = {
    kosei.doom-emacs = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.doom.emacs = {
      enable = true;
      doomPrivateDir = ./config/doom.d;
      emacsPackage = pkgs.emacsPgtk;
    };
    home = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [
            ".config/doom.d"
          ];
        };
      };
    };
  };
}

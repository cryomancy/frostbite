scoped: {
  config,
  inputs,
  pkgs,
  lib,
  system,
  user,
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
    # TODO: find a way to incorporate impermanence statement
    persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [
          ".local/share/nvim"
          ".config/emacs"
          ".config/doom"
          ".local/share/doom"
          "./local/state/doom"
        ];
      };
    };
    home.packages = [cfg.defaultEditor];
  };
}

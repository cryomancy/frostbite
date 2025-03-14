scoped: {
  config,
  inputs,
  lib,
  system,
  user,
  ...
}: let
  cfg = config.kosei.fuyuvim;
  inherit (inputs.fuyuvim.packages.${system}) fuyuvim;
in {
  options = {
    kosei.fuyuim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [
            ".local/share/nvim"
          ];
        };
      };
      packages = [fuyuvim];
    };
  };
}

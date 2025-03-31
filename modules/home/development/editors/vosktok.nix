_: {
  config,
  inputs,
  lib,
  system,
  user,
  ...
}: let
  cfg = config.frostbite.editors.vostok;
  inherit (inputs.vostok.packages.${system}) vostok;
in {
  options = {
    frostbite.editors.vostok = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/home/${user}" = {
          directories = [
            ".local/share/nvim"
          ];
        };
      };
      packages = [vostok];
    };
  };
}

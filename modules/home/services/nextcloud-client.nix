_:
{
  config,
  lib,
  ...
}:
let
  cfg = config.frostbite.services.nextcloud-client;
in
{
  options = {
    frostbite.services.nextcloud-client = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    home.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/persist/${config.home.homeDirectory}".directories = [ ".config/nextcloud-client" ];
    };
  };
}

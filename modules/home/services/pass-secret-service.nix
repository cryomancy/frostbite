_: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.frostbite.services.pass-secret-service;
  storePath = "/home/${user}/.local/share/passwore-store";
in {
  options = {
    frostbite.services.pass-secret-service = {
      enable = lib.mkEnableOption "pass-secret-service";
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.frostbite.services.impermanence.enable {
      "/nix/persistent/home/${user}" = {
        directories = [
          storePath
        ];
      };
    };
    services = {
      pass-secret-service = {
        enable = true;
        inherit storePath;
      };
    };
  };
}

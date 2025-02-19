scoped: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.pass-secret-service;
  storePath = "/home/${user}/.local/share/passwore-store";
in {
  options = {
    kosei.pass-secret-service = {
      enable = lib.mkEnableOption "pass-secret-service";
    };
  };

  config = lib.mkIf cfg.enable {
    home.persistence = lib.mkIf config.kosei.impermanence.enable {
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

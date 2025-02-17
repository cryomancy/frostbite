scoped: {
  config,
  lib,
  user,
  ...
}: let
  cfg = config.kosei.pass-secret-service;
in {
  options = {
    kosei.pass-secret-service = {
      enable = lib.mkEnableOption "pass-secret-service";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      pass-secret-service = {
        enable = true;
        storePath = "/home/${user}/.local/share/password-store";
      };
    };
  };
}

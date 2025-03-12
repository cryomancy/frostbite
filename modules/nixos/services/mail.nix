_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.email;
in {
  options = {
    kosei.email = {
      enable = lib.mkEnableOption "email and email-server options";
      address = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.address;
    };
  };
}

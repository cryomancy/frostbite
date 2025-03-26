_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.services.resolved;
in {
  options = {
    kosei.networking.services.resolved = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      resolved = {
        enable = true;
        fallbackDns = [
          "1.1.1.1" # Cloudflare DNSSEC
        ];
        dnssec = "allow-downgrade";
        dnsovertls = "opportunistic";
        llmnr = "true";
      };
    };
  };
}

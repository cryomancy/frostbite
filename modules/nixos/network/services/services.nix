_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.services.resolved;
in {
  options = {
    frostbite.networking.services.resolved = lib.mkOption {
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

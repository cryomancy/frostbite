_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.services.resolved;
in {
  options = {
    frostbite.networking.services.resolved = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      # THIS ALLOWS RESOLVED TO ACT AS A COMPLETE mDNS
      localDNSResolver = lib.mkOption {
        type = lib.types.str;
        default = null;
        example = "https://192.168.1.254";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      resolved = {
        enable = true;
        domains = ["~."];
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

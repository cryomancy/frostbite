_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.networking.firewall;
in {
  options = {
    frostbite.networking.firewall = lib.mkOption {
      type = lib.types.submodule;
      options = lib.mkOption {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nftables = {
        enable = true;
        checkRuleset = true;
        checkRulesetRedirect = {
          "/etc/hosts" = config.environment.etc.hosts.source;
          "/etc/protocols" = config.environment.etc.protocols.source;
          "/etc/services" = config.environment.etc.services.source;
        };

        flushRuleset = true;

        tables = {
          ssh = {
            content = builtins.readFile ./tables/__ssh.conf;
          };

          dns = {
            content = builtins.readFile ./tables/__dns.conf;
          };

          # NOTE: Also includes HTTPS
          http = {
            content = builtins.readFile ./tables/_http.conf;
          };

          ping = {
            content = builtins.readFile ./tables/_http.conf;
          };
        };
      };
    };
  };
}

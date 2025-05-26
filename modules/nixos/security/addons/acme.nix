_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.security.acme;
  secOpts = config.frostbite.security;
  isStrict = secOpts.level == "strict";
  enableIfStrict =
    if isStrict
    then true
    else false;
  disableIfStrict =
    if isStrict
    then false
    else true;
in {
  options = {
    frostbite.security = {
      acme = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = null;
      };

      useAWS = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.frostbite.security.impermanence.enable {
        "/nix/persistent/".directories = [];
      };
    };

    security.acme = {
      acceptTerms = true;
      preliminarySelfsigned = disableIfStrict;
      maxConcurrentRenewals = 5;

      defaults = {
        server = "https://acme-v02.api.letsencrypt.org/directory";

        dnsProvider = lib.mkIf cfg.useDNS "route53";
        dnsResolver = "8.8.8.8:53";

        environmentFile = "${config.sops.templates."certs.secret".path}";

        enableDebugLogs = true;

        inherit (cfg) email;

        group = "acme";

        webroot = null;

        keyType = "ec256";

        validMinDays = 30;
      };
    };

    # These are used to access AWS for DNS validation
    # Must have a key:value pair for each of these
    sops.secrets = lib.mkIf cfg.useAWS {
      "AWS_ACCESS_KEY_ID" = {};
      "AWS_SECRET_ACCESS_KEY" = {};

      templates = {
        "certs.secret" = {
          content = ''
            AWS_ACCESS_KEY_ID = "${config.sops.placeholder."AWS_ACCESS_KEY_ID"}"
            AWS_SECRET_ACCESS_KEY = "${config.sops.placeholder."AWS_SECRET_ACCESS_KEY"}"
          '';
          owner = "acme";
        };
      };
    };
  };
}

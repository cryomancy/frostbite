_: {
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.frostbite.services.server.email;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    frostbite.services.server.email = {
      enable = lib.mkEnableOption "email and email-server options";
      address = lib.mkOption {
        type = lib.types.str;
        default = null;
      };
      server = {
        type = lib.types.submodule {
          domains = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = null;
          };
          name = lib.mkOption {
            type = lib.types.str;
            default = null;
          };
        };
      };
    };
  };

  imports = [inputs.simple-nixos-mailserver.nixosModule];

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      defaults.email = cfg.address;
    };

    containers = {
      mail = {
        autoStart = true;
        config = _: {
          networking.firewall.allowedTCPPorts = [80 443];

          mailserver = {
            enable = true;
            enableImap = true;
            enableImapSsl = true;
            enableManageSieve = true;
            enableSubmission = true;
            enableSubmissionSsl = true;
            localDnsResolver = true;
            openFirewall = true;
            useFsLayout = true;
            virusScanning = true;

            rebootAfterKernelUpgrade.enable = true;

            enablePop3 = false;
            enablePop3Ssl = false;

            inherit (cfg.server) domains;
            inherit (cfg.server.name) fqdn;
            inherit (cfg.server.accounts) loginAccounts;

            indexDir = "/var/mail/dovecot/indices";
            mailDirectory = "/var/mail";
            sieveDirectory = "/var/mail/sieve";
            certificateDirectory = "/var/mail/certs";
            dkimKeyDirectory = "/var/mail/dkim";

            keyFile = config.sops.secrets."$mail/keyFile".path;
            vmailUserName = "mail";
            vmailGroupName = "mail";
            vmailUID = 5555;

            dkimBodyCanonicalization = "relaxed";
            dkimHeaderCanonicalization = "relaxed";
            dkimKeyBits = 2048;

            fullTextSearch = {
              enable = true;
              # index new email as they arrive
              autoIndex = true;
              # this only applies to plain text attachments, binary attachments are never indexed
              indexAttachments = true;
              enforced = "body";
            };
          };

          services = {
            roundcube = {
              enable = true;
              # this is the url of the vhost, not necessarily the same as the fqdn of
              # the mailserver
              hostName = "webmail.example.com";
              extraConfig = ''
                # starttls needed for authentication, so the fqdn required to match
                # the certificate
                $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
                $config['smtp_user'] = "%u";
                $config['smtp_pass'] = "%p";
              '';
            };

            nginx.enable = true;
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}

_: {
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.frostbite.programs.gpg;
in {
  options = {
    frostbite.programs.gpg = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = "gpg";
          };
          keyID = lib.mkOption {
            type = lib.types.str;
            default = null;
          };
          commitSigning.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gpg-tui # Terminal user interface for GnuPG
      gpgme # Library for making GnuPG easier to use
    ];
    programs = {
      gpg = {
        enable = true;
        homedir = "${config.xdg.configHome}/gnupg";
        package = pkgs.gpg-true;
        settings = {
          personal-cipher-preferences = "AES256 AES192 AES";
          personal-digest-preferences = "SHA512 SHA384 SHA256";
          personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
          default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
          cert-digest-algo = "SHA512";
          s2k-digest-algo = "SHA512";
          s2k-cipher-algo = "AES256";
          charset = "utf-8";
          fixed-list-mode = true;
          no-comments = true;
          no-emit-version = true;
          keyid-format = "0xlong";
          list-options = "show-uid-validity";
          verify-options = "show-uid-validity";
          with-fingerprint = true;
          require-cross-certification = true;
          no-symkey-cache = true;
          use-agent = true;
          throw-keyids = true;
        };
        scdaemonSettings = {
          disable-ccid = true;
        };
      };

      git = lib.mkIf (config.kosei.git.enable && cfg.commitSigning.enable) {
        signing.key = "${cfg.keyID}";
        extraConfig.commit.gpgsign = true;
      };
    };
  };
}

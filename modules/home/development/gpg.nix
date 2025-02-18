scoped: {
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kosei.gpg;
in {
  options = {
    kosei.gpg = {
      enable = lib.mkOption {
        default = true;
        example = false;
        description = "gpg";
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
        enableBrowserSocket = true;
        enableExtraSocket = true;
        enableSSHSupport = true;
        package = pkgs.gpg-true;
      };
    };
  };
}

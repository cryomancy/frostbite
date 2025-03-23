_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.security.antivirus;
  secOpts = config.kosei.security.settings;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    kosei.security = {
      antivirus = lib.mkOption {
        type = lib.types.submodule;
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
      clamav = {
        daemon.enable = !isOpen true;
        updater.enable = !isOpen true;
      };
    };

    environment.systemPackages = [
      pkgs.clamtk
    ];
  };
}

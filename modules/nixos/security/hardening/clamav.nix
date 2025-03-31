_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.security.clamav;
  secOpts = config.frostbite.security;
  isOpen = lib.mkIf secOpts.level == "open";
in {
  options = {
    frostbite.security.clamav = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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

_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.security.clamav;
  secOpts = config.frostbite.security;
  isSecure = lib.mkIf secOpts.level != "open";
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
        daemon.enable = lib.mkIf isSecure true;
        updater.enable = lib.mkIf isSecure true;
      };
    };

    environment.systemPackages = [
      pkgs.clamtk
    ];
  };
}

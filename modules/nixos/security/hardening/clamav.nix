_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.security.clamav;
  secOpts = config.frostbite.security;
  enableIfSecure = let
    isSecure = secOpts.level != "open";
  in
    if isSecure
    then true
    else false;
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
        daemon.enable = enableIfSecure;
        updater.enable = enableIfSecure;
      };
    };

    environment.systemPackages = [
      pkgs.clamtk
    ];
  };
}

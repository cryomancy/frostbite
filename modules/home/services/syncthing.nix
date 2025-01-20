scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.syncthing;
in {
  options = {
    kosei.syncthing = {
      enable = lib.mkEnableOption "syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
      };
    };
    #systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };
}

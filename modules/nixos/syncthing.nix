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
      syncthing = lib.mkIf cfg.syncthing.enable {
        settings = {
          enable = true;
          openDefaultPorts = true;
          # TODO: decide where folders get specified (user-config?)
        };
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };
}

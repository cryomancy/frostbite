_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.services.ipc.dbus;
in {
  options = {
    kosei.services.ips.dbus = lib.mkOption {
      type = lib.types.submodule {
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
      dbus = {
        enable = true;
        implementation = "broker";
        apparmor = "disabled"; # System is secured by SELinux;
      };
    };
  };
}

_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.ipc.dbus;
in {
  options = {
    frostbite.services.ipc.dbus = lib.mkOption {
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

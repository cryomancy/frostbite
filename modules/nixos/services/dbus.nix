_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.dbus;
in {
  options = {
    frostbite.services.dbus = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
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

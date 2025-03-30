_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.initrdSSH;
in {
  options = {
    frostbite.services.initrdSSH = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.network = {
      enable = true;
      ssh.enable = true;
      # NOTE: everything else is inherited from
      # the SSH frostbite module / NixOS modules
    };
  };
}

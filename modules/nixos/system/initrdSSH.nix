scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.initrdSSH;
in {
  options = {
    kosei.initrdSSH = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.network = {
      enable = true;
      ssh.enable = true;
      # NOTE: everything else is inherited from
      # the SSH kosei module / NixOS modules
    };
  };
}

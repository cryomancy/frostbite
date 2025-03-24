_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.firewall;
in {
  options = {
    kosei.networking = {
      firewall = {
        type = lib.types.submodule;
        option = lib.mkOption {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowPing = (lib.mkIf (cfg.level < 4)) true;
        allowedTCPPorts = lib.lists.concatLists [
          [80 443]
        ];
      };

      nftables = {
        enable = true;
      };
    };

    services = {
      openssh.openFirewall = lib.mkIf config.kosei.ssh.enable true;
    };
  };
}

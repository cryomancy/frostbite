_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.networking.wireguard;
in {
  options = {
    kosei.servers.wireguard = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.network = {
      netdevs = {
        "50-wireguard" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wireguard";
            MTUBytes = "1300";
          };
          wireguardConfig = {
            PrivateKeyFile = "/run/keys/wireguard-privkey";
            ListenPort = 51820;
            RouteTable = "main";
          };
          wireguardPeers = [
            {
              PublicKey = "${cfg.publicKey}";
              AllowedIPs = ["10.100.0.2"];
            }
          ];
        };
      };

      netdevs = {
        "50-wireguard" = {
          address = ["10.100.0.1/24"];
          networkConfig = {
            IPMasquerade = "ipv4";
            IPForward = true;
          };
        };
      };
    };
  };
}

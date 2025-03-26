_: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.networking.wireguard;
in {
  options = {
    kosei.networking.wireguard = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          server = lib.mkOption {
            type = lib.types.str;
            default = null;
            description = "IP Address of the wireguard server you are connecting to.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 51820;
            description = "Port used by the wireguard server you are connecting to.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.network = {
      netdevs = {
        "10-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
            MTUBytes = "1300";
          };
          wireguardConfig = {
            PrivateKeyFile = "${cfg.privateKey}.path";
            ListenPort = 9918;
          };
          wireguardPeers = [
            {
              PublicKey = "${cfg.publicKey}";
              AllowedIPs = ["10.100.0.1"];
              Endpoint = "${cfg.ip}:${cfg.port}";
            }
          ];
        };
      };

      networks = {
        "50-wireguard" = {
          matchConfig.Name = "wg0";
          address = [
            "fe80::3/64"
            "fc00::3/120"
            "10.100.0.2/24"
          ];
          DHCP = "no";
          dns = ["fc00::53"];
          ntp = ["fc00::123"];
          gateway = [
            "10.100.0.1"
          ];
          networkConfig = {
            IPv6AcceptRA = false;
          };
        };
      };
    };
  };
}

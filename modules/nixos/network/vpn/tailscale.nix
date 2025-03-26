_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.networking.vpn.tailscale;
in {
  options = {
    kosei.networking.tailscale = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          authKeyFile = {
            type = lib.tpes.str;
            default = null;
            example = "config.kosei.secrets.tailscale.authKeyFile.path";
            description = ''A one-time use key used to authenticate a single device to Tailscale.'';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.tailscale];
    services = {
      tailscale = {
        enable = true;
        port = 41641;
        interfaceName = "tailscale";
        authKeyFile =
          if cfg.authKeyFile != null
          then cfg.authKeyFile
          else null;
      };
    };
  };
}

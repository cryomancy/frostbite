scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.i2pd;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.i2pd = {
      enable = lib.mkEnableOption "i2pd";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xd
    ];

    # TODO: Asserts secrets must be enabled
    containers = {
      i2pd-container = {
        autoStart = true;
        config = _: {
          networking.firewall.allowedTCPPorts = [
            7656 # SAM
            7070 # Web Interface
            4447 # SOCKS Proxy
            4444 # HTTP Proxy
          ];

          services.i2pd = {
            enable = true;
            address = "127.0.0.1";
            proto = {
              http.enable = true;
              socksProxy.enable = true;
              httpProxy.enable = true;
              sam.enable = true;
            };
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}

_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.server.matrix;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    frostbite.server.matrix = {
      enable = lib.mkEnableOption "matrix";
    };
  };
  config = lib.mkIf cfg.enable {
    # TODO: Asserts secrets must be enabled
    containers = {
      matrix-container = {
        autoStart = true;
        config = _: {
          services.matrix-synapse = {
            enable = true;
            registrationUrl = "localhost";
            settings = {
              homeserver.url = "localhost";
            };
          };

          networking.firewall = {
            allowedTCPPorts = [58846];
            allowedTCPPortRanges = [
              {
                from = 6880;
                to = 6890;
              }
            ];
          };

          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}

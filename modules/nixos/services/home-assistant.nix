scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.home-assistant;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.home-assistant = {
      enable = lib.mkEnableOption "home-assistant";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/home-assistant"];
    };

    # TODO: Asserts secrets must be enabled
    containers = {
      home-assistant-container = {
        autoStart = true;
        config = _: {
          services.home-assistant = {
            enable = true;
            openFirewall = true; # Forward listen ports
          };

          networking.firewall = {
            # Remote control port
            allowedTCPPorts = [58846];
            # Listen
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

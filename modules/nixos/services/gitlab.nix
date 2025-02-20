scoped: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.gitlab;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    kosei.gitlab = {
      enable = lib.mkEnableOption "gitlab";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gitlab-shell
    ];

    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = ["/var/gitlab"];
    };

    # TODO: Asserts secrets must be enabled
    containers = {
      gitlab-container = {
        autoStart = true;
        config = {pkgs, ...}: {
          services.gitlab = {
            enable = true;
            pages.enable = true;
            packages.gitlab = pkgs.gitlab;
            port = 3080;
            smtp = {
              enable = false;
              port = 25;
            };
          };

          services.gitlab-runner = {
            enable = true;
            settings = {
            };
          };

          networking.firewall = {
            allowedTCPPorts = [3080];
            allowedTCPPortRanges = [
              {
                from = 6980;
                to = 6990;
              }
            ];
          };
          system.stateVersion = systemStateVersion;
        };
      };
    };
  };
}

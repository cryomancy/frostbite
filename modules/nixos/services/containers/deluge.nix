_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.services.containers.deluge;
  systemStateVersion = config.system.stateVersion;
in {
  options = {
    frostbite.services.containers.deluge = {
      enable = lib.mkEnableOption "deluge";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitmagnet
    ];

    # TODO: Asserts secrets must be enabled
    containers = {
      deluge-container = {
        autoStart = true;
        config = _: {
          services.deluge = {
            enable = true;
            config = {
              copy_torrent_file = true;
              move_completed = true;
              torrentfiles_location = "/srv/torrents/files";
              download_location = "/srv/torrents/downloading";
              move_completed_path = "/srv/torrents/completed";
              dont_count_slow_torrents = true;
              max_active_seeding = -1;
              max_active_limit = -1;
              max_active_downloading = 8;
              max_connections_global = -1;
              # Daemon on 58846
              allow_remote = true;
              daemon_port = 58846;
              # Listen on 6880 only
              random_port = false;
              listen_ports = [
                6880
                6880
              ];
              # Outgoing is random
              random_outgoing_ports = true;
            };
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

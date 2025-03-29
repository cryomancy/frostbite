_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.virtualisation.podman;
in {
  options = {
    frostbite.virtualisation.podman = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = [
        "/var/lib/containers"
      ];
    };

    virtualisation = {
      podman = {
        autoPrune.enable = true;
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        networkSocket.openFirewall = lib.mkIf config.firewall.enable;
      };
      lxd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      docker-compose # start group of containers for dev
    ];
  };
}

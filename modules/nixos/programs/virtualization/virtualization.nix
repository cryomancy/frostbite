scoped: {
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.virtualization;
in {
  options = {
    kosei.virtualization = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = [
        "/var/lib/containers"
        "/var/lib/libvirt"
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
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu.runAsRoot = true;
      };
      lxd.enable = true;
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu_kvm
      qemu
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      docker-compose # start group of containers for dev
    ];
  };
}

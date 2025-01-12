scoped: {
  config,
  hostName,
  inputs,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.kosei.virtualization;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  options = {
    kosei.virtualization = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      wsl = {
        enable = lib.mkEnableOption "WSL Integration";
      };
      waydroid.enable = lib.mkEnableOption "waydroid";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      podman = {
        autoPrune.enable = true;
        enable = true;
        defaultNetwork.settings.dns_enabled = true;
        dockerCompat = true;
        dockerSocket.enable = true;
        networkSocket.openFirewall = lib.mkIf config.firewall.enable;
      };

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

    wsl = lib.mkIf cfg.wsl.enable {
      enable = true;
      defaultUser = builtins.elemAt users 0;
      startMenuLaunchers = true;

      wslConf = {
        automount.root = "/mnt";
        interop.appendWindowsPath = false;
        network.generateHosts = false;
        network.hostname = "${hostName}";
      };
    };

    virtualisation.waydroid.enable = lib.mkIf cfg.waydroid.enable true;

    kosei.boot.enable = (lib.mkIf cfg.wsl.enable) (lib.mkForce false);
  };
}

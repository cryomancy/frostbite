_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.virtualisation.qemu;
in {
  options = {
    frostbite.virtualisation.qemu = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = [
        "/var/lib/libvirt"
      ];
    };

    virtualisation = {
      spiceUSBRedirection.enable = true;

      libvirtd = {
        enable = true;
        qemu.runAsRoot = true;
      };
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu_kvm
      qemu
    ];
  };
}

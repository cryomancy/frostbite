{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.fuyuNoKosei.services;
in {
  options = {
    fuyuNoKosei.services = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      ssh.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      laptop.enable = lib.mkEnableOption "laptop";
      virtualMachine.enable = lib.mkEnableOption "virtual machine";
      yubikey.enable = lib.mkEnableOption "yubikey";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = lib.mkIf cfg.ssh.enable {
        enable = true;
        settings = {
          banner = "冬の国境";
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = true;
          UsePAM = true;
        };
      };

      logind = lib.mkIf cfg.laptop.enable {
        lidSwitch = "suspend";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      };
    };

    programs = {
      ssh = lib.mkIf cfg.ssh.enable {
        startAgent = true;
        # Yubi-Key
        extraConfig = lib.mkIf cfg.yubikey.enable ''
          AddKeysToAgent yes
        '';
      };
    };

    hardware.sensor.iio.enable = lib.mkIf cfg.laptop.enable true;

    services = {
      qemuGuest.enable = lib.mkIf cfg.virtualMachine.enable true;
      spice-vdagentd.enable = lib.mkIf cfg.virtualMachine.enable true;
      avahi.enable = true;
    };
  };
}

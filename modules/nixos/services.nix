{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services;
in {
  options = {
    services = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      fuyuSSH.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      laptop.enable = lib.mkEnableOption "laptop";
      gamemode.enable = lib.mkEnableOption "gamemode";
      virtualMachine.enable = lib.mkEnableOption "virtual machine";
      yubikey.enable = lib.mkEnableOption "yubikey";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      openssh = lib.mkIf cfg.fuyuSSH.enable {
        enable = true;
        settings = {
          banner = "冬の国境";
          PermitRootLogin = "no";
          PassswordAuthentication = false;
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
      ssh = lib.mkIf cfg.openssh.enable {
        startAgent = true;
        # Yubi-Key
        extraConfig = lib.mkIf cfg.yubikey.enable ''
          AddKeysToAgent yes
        '';
      };
      gamemode = lib.mkIf cfg.gamemode.enable {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
          gpu = {
            apply_gpu_optimizations = "accept-responsibility";
            gpu_device = 0;
          };
        };
      };
      steam = lib.mkIf cfg.gamemode.enable {
        enable = true;

        # NOTE: Fix Gamescope inside Steam
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              keyutils
              libkrb5
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
            ];
        };
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

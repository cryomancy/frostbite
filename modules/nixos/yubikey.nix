scoped: {
  config,
  lib,
  pkgs,
  users,
  ...
}: let
  cfg = config.kosei.yubikey;
in {
  options = {
    kosei.yubikey.enable = lib.mkEnableOption "yubikey";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pam_u2f
      age-plugin-yubikey
      yubioath-flutter
      yubikey-manager
    ];

    services = {
      pcscd.enable = true; # Smart card mode
      yubikey-agent.enable = true;
      udev = {
        packages = with pkgs; [yubikey-personalization libu2f-host];
        # Lock on yubikey removal
        extraRules = ''
          ACTION=="remove",\
           ENV{ID_BUS}=="usb",\
           ENV{ID_MODEL_ID}=="0407",\
           ENV{ID_VENDOR_ID}=="1050",\
           ENV{ID_VENDOR}=="Yubico",\
           RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        '';
      };
    };

    security.pam = lib.optionalAttrs pkgs.stdenv.isLinux {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true;
          authFile = "/etc/secure/Yubico/u2f_keys";
          interactive = true;
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };

    programs = {
      ssh = lib.mkIf config.kosei.ssh.enable {
        startAgent = false;
      };
      yubikey-touch-detector.enable = true;
    };
  };
}

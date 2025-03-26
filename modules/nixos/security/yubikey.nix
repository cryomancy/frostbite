_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.kosei.security.yubikey;
in {
  options = {
    kosei.security.yubikey = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence = lib.mkIf config.kosei.impermanence.enable {
        "/nix/persistent/".directories = ["/etc/secure/Yubico/u2f_keys"];
      };

      systemPackages = with pkgs; [
        pam_u2f
        age-plugin-yubikey
        yubioath-flutter
        yubikey-manager
      ];
    };

    services = {
      pcscd.enable = true; # Smart card mode
      yubikey-agent.enable = true;
      udev = {
        packages = with pkgs; [yubikey-personalization libu2f-host];
        # Lock on yubikey removal
        # Do NOT use the rule below https://github.com/keepassxreboot/keepassxc/issues/10077
        # extraRules = ''
        #  ACTION=="remove",\
        #   ENV{ID_BUS}=="usb",\
        #   ENV{ID_MODEL_ID}=="0407",\
        #   ENV{ID_VENDOR_ID}=="1050",\
        #   ENV{ID_VENDOR}=="Yubico",\
        #   RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
        # '';
        extraRules = ''
          ACTION=="remove",\
          ENV{SUBSYSTEM}=="usb",\
          ENV{PRODUCT}=="1050/407/XXX",\
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

      # Enable the u2f PAM module for login and sudo requests
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };

    programs = {
      yubikey-touch-detector.enable = true;
    };
  };
}

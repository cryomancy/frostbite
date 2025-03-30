_: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.frostbite.services.yubikey-agent;
in {
  options = {
    frostbite.services.yubikey-agent = {
      enable = mkOption {
        type = types.bool;
        default = config.frostbite.security.yubikey.enable;
        description = ''
          Whether to start yubikey-agent when you log in.
          Also sets SSH_AUTH_SOCK to point at yubikey-agent.
        '';
      };

      package = mkPackageOption pkgs "yubikey-agent" {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    systemd.packages = [cfg.package];

    # This overrides the systemd user unit shipped with the
    # yubikey-agent package
    systemd.user.services.yubikey-agent = {
      path = [pkgs.pinentry-curses];
      wantedBy = ["default.target"];
    };

    # Yubikey-agent expects pcsd to be running in order to function.
    services.pcscd.enable = true;

    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/yubikey-agent/yubikey-agent.sock"
      fi
    '';
  };
}

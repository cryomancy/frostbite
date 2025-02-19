scoped: {
  config,
  lib,
  ...
}: let
  cfg = config.kosei.ssh;
in {
  options = {
    kosei.ssh = {
      enable = lib.mkEnableOption "ssh";
      level = lib.mkOption {
        type = lib.types.ints.between 0 2;
        default = 2;
      };
      publicKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
      "/nix/persistent/".directories = [
        "/etc/ssh"
      ];
    };
    services = {
      openssh = {
        enable = true;
        startWhenNeeded = (lib.mkIf (cfg.level > 1)) true;
        settings = {
          Banner = "冬の国境";
          PasswordAuthentication = (lib.mkIf (cfg.level > 0)) false;
          PermitRootLogin =
            if cfg.level == 0
            then "yes"
            else "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = (lib.mkIf (cfg.level < 2)) true;
          UsePAM = true;
        };
      };
    };
  };
}

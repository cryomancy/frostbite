_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.services.daemon.ssh;
  secOpts = config.frostbite.security.settings;
in {
  options = {
    frostbite.services.daemon.ssh = {
      enable = lib.mkEnableOption "ssh";
      publicKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.impermanence.enable {
      "/nix/persistent/".directories = [
        "/etc/ssh"
      ];
    };
    services = {
      openssh = {
        enable = !secOpts.lockdownState;
        startWhenNeeded =
          if (secOpts.useCase == "server")
          then "yes"
          else "no";
        settings = {
          Banner = "冬の国境";
          PasswordAuthentication =
            if (secOpts.useCase != "server" || secOpts.useCase != "laptop")
            then true
            else false;
          PermitRootLogin =
            if (secOpts.level == "open")
            then "yes"
            else "no";
          KbdInteractiveAuthentication = false;
          X11Forwarding = (lib.mkIf (secOpts.useCase != "server")) true;
          UsePAM = true;
        };
      };
    };
  };
}

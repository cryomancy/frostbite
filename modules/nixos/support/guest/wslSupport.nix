_: {
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.frostbite.support.guest.wsl;
  users = config.frostbite.users.accounts;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  options = {
    frostbite.support.guest.wsl = {
      enable = lib.mkEnableOption "WSL";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      # TODO: dive deeper into the exact WSL mounts
      "/nix/persistent/".directories = ["/mnt"];
    };

    wsl = {
      enable = true;
      defaultUser = builtins.elemAt users 0;
      startMenuLaunchers = true;

      wslConf = {
        automount.root = "/mnt";
        interop.appendWindowsPath = false;
        network.generateHosts = false;
        network.hostname = config.system.name;
      };
    };

    frostbite.boot.enable = lib.mkForce false;
  };
}

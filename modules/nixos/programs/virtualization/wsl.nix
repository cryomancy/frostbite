scoped: {
  config,
  inputs,
  lib,
  users,
  ...
}: let
  cfg = config.kosei.wsl;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];

  options = {
    kosei.wsl = {
      enable = lib.mkEnableOption "WSL";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.persistence = lib.mkIf config.kosei.impermanence.enable {
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

    kosei.boot.enable = lib.mkForce false;
  };
}

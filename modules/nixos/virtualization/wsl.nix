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

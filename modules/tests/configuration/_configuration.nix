{
  inputs,
  outPath,
  pkgs,
  lib,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [wl-gammarelay-applet iwgtk];
    frostbite = {
      display.design.theme = "${inputs.assets}/themes/nord.yaml";
      support.laptop = {
        enable = true;
        enableHyprlandSupport = true;
      };
      services.ssh = {
        publicKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDRUJCFyU2Bhag5GHGq2ihZL6LljX8EZygeKU6KDzHL8 tbrahic@proton.me"
        ];
      };
      security = {
        useCase = "laptop";
        yubikey.enable = true;
      };

      networks.enable = false;

      users.users = {
        tahlon = {
          isAdministrator = lib.mkForce true;
        };
      };
    };
  };
}

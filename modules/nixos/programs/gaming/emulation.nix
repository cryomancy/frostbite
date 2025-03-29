_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.gaming.emulation;
in {
  options = {
    frostbite.gaming.emulation = {
      enable = lib.mkEnableOption "emulation";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam-rom-manager
      bottles
      emulationstation-de
      ryujinx # Experimental Nintendo Switch Emulator written in C#
      retroarchFull
    ];
  };
}

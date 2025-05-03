_: {
  lib,
  pkgs,
}:
lib.getExe
(
  pkgs.writeShellApplication
  {
    name = "onMonitorDetached.sh";
    runtimeInputs = with pkgs; [hyprland waybar];
    text = ''
      hyprctl dispatch dpms on eDP-1
      pkill waybar; waybar
    '';
  }
)

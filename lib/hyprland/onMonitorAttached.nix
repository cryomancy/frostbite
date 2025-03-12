scoped: {
  lib,
  pkgs,
}:
(pkgs.writeShellApplication
  {
  name = "onMonitorAttached.sh";
  runtimeInputs = with pkgs; [hyprland waybar];
  text = ''
    hyprctl dispatch dpms off eDP-1
    pkill waybar; waybar
  '';
  }
)
|> lib.getExe

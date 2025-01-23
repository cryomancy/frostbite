scoped: {
  config,
  lib,
  pkgs,
}: parameter: let
  hyprlandGamemodePrograms = lib.makeBinPath [
    config.programs.hyprland.package
    pkgs.coreutils
    pkgs.power-profiles-daemon
  ];
in
  lib.writeShellScriptBin "gamemode" ''
     if [${parameter} -eq "start"]
       export PATH=$PATH:${hyprlandGamemodePrograms}
       export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
       hyprctl --batch 'keyword decoration:blur 0 ; keyword animations:enabled 0 ; keyword misc:vfr 0'
       powerprofilesctl set performance
     elif [${parameter} -eq "stop"]
    export PATH=$PATH:${hyprlandGamemodePrograms}
       export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 /tmp/hypr | tail -1)
       hyprctl --batch 'keyword decoration:blur 1 ; keyword animations:enabled 1 ; keyword misc:vfr 1'
       powerprofilesctl set power-saver
     fi
  ''

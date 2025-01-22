scoped: {
  name ? "customScript",
  text,
  dependencies ? [],
  lib ? {inherit lib;},
  pkgs ? {inherit pkgs;},
}: let
  inherit (lib) getExe;
in
  getExe (pkgs.writeShellApplication {
    inherit name text;
    runtimeInputs = with pkgs; [coreutils gnugrep systemd] ++ dependencies;
  })

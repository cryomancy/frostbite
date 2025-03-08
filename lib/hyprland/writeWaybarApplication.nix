scoped: {
  lib,
  pkgs,
}: {
  name ? "customScript",
  text,
  dependencies ? [],
}: let
  inherit (lib) getExe;
  inherit (pkgs) writeShellApplication;
in
  getExe (writeShellApplication {
    inherit name text;
    runtimeInputs = with pkgs; [coreutils gnugrep systemd] ++ dependencies;
  })

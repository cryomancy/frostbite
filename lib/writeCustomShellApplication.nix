{
  lib,
  pkgs,
}: let
  # Wrapper that returns the path of a programs written as a derivation to the nix store
  inherit lib;
  writeCustomShellApplication = {
    name ? "customScript",
    script, # script
    dependencies ? [],
  }:
    lib.getExe (pkgs.writeShellApplication {
      inherit name;
      text = script;
      runtimeInputs = with pkgs; [coreutils gnugrep systemd] ++ dependencies;
    });
in
  writeCustomShellApplication

scoped: {
  name ? "customScript",
  text,
  dependencies ? [],
  lib ? {inherit lib;},
  pkgs ? {inherit pkgs;},
}:
lib.getExe (pkgs.writeShellApplication {
  inherit name text;
  runtimeInputs = with pkgs; [coreutils gnugrep systemd] ++ dependencies;
})

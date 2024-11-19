{
  lib,
  pkgs,
  ...
}: {
  backupFileExtension = lib.readFile "${pkgs.runCommand "timestamp" {env.when = builtins.currentTime;} "echo -n `date -d @$when +%Y-%m-%d_%H-%M-%S` > $out"}";
}

scoped: {pkgs, ...}:
pkgs.runCommand "generateAgeKey" ''
    nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"
  ''

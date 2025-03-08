_: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "generateAgeKey";
  text = ''
    nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"
  '';
}

scoped: {pkgs, ...}:
pkgs.runCommand "yubikeyTest" ''
  nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"
''

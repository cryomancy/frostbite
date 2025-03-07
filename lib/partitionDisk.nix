scoped: {pkgs, ...}:
pkgs.runCommand "partitionDisk" ''
  sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko --mode disko ./lib/diskoBTRFS.nix --arg device '"/dev/vga"'
''

scoped: {pkgs, ...}:
pkgs.runCommand "viewInputs" ''
  nix run github:nix-community/nix-melt
''

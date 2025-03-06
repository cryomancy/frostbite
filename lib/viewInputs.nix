scoped: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "viewInputs";
  text = ''
    nix run github:nix-community/nix-melt
  '';
}

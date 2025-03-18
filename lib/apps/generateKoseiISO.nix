_: {pkgs}:
pkgs.writeShellApplication {
  name = "nixosGenerate";
  text = ''
    nix build .#nixosConfigurations.iso.isoImage
  '';
}

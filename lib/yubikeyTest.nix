scoped: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "yubikeyTest";
  text = ''
    nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"
  '';
}

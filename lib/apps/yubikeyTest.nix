_: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "yubikeyTest";
  runtimeInputs = with pkgs; [pamtester];
  text = ''
    nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"
  '';
}

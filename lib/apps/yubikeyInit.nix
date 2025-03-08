_: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "yubikeyInit";
  runtimeInputs = with pkgs; [pamtester];
  text = ''
    nix-shell -p pam_u2f --run "mkdir -p ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys"
  '';
}

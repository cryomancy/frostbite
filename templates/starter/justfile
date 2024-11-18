default:
  @just --list

rebuild:
  git add .
  sudo nixos-rebuild switch

yubikey-init:
  nix-shell -p pam_u2f --run "mkdir -p ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys"

yubikey-test:
  nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"

default:
  @just --list

rebuild:
  git add .
  sudo nixos-rebuild switch

yubikey-init:
  nix-shell -p pam_u2f --run "mkdir -p ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys"

yubikey-test:
  nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"

generate-age-key:
  nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"

lock:
  nix flake update
  nix run github:TahlonBrahic/nix-auto-follow -- -i
  nix run github:TahlonBrahic/nix-auto-follow -- -c

view-inputs:
  nix run github:nix-community/nix-melt

partition-disk
  sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko --mode disko ./lib/diskoBTRFS.nix --arg device '"/dev/vga"'

default:
  @just --list

rebuild:
  git add .
  sudo nixos-rebuild switch

yubikey-init:
  nix-shell -p pam_u2f --run "mkdir -p ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys"

yubikey-test:
  nix-shell -p pamtester --run "pamtester login $USER authenticate && pamtester sudo $USER authenticate"

sops-mkpasswd:
  echo (read "Enter your password:") | mkpasswd -s

lock:
  nix flake update
  nix run github:TahlonBrahic/nix-auto-follow -- -i
  nix run github:TahlonBrahic/nix-auto-follow -- -c

view-inputs:
  nix run github:nix-community/nix-melt

pause-yubikey-agent:
  killall -HUP yubikey-agent

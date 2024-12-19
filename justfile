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
    # The public key added to .sops.yaml would then have to be updated with sops updatekeys
	# on a host with a key already in secrets/secrets.yaml
	# Then the previous secrets in secrets/secrets.yaml can be accessed

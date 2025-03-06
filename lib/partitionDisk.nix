scoped: {pkgs, ...}:
pkgs.writeShellApplication {
  name = "partitionDisk";
  text = ''
    sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko --mode disko ./lib/diskoBTRFS.nix --arg device '"/dev/vga"'
  '';
}

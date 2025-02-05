{pkgs ? import <nixpkgs> {system = "x86_64-linux";}}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      # Nix
      nix
      home-manager

      git
      # Formatters & Linters
      bashInteractive
      alejandra
      deadnix
      statix
      typos
      nodePackages.prettier

      # Secrets Management
      sops
      age
    ];
  };
}

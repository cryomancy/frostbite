{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";
  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore.url = "github:hercules-ci/gitignore.nix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = _: {};
}

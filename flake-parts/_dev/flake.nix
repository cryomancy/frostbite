{
  description = "Private inputs for development purposes. These are used by the top level flake in the `dev` partition, but do not appear in consumers' lock files.";
  inputs = {
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    # See https://github.com/ursi/get-flake/issues/4
    git-hooks-nix.inputs.nixpkgs.follows = "";
  };

  # This flake is only used for its inputs.
  outputs = _: {};
}

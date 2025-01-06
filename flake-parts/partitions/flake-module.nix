localFlake: {self, ...}: {
  partitions = {
    dev = {
      extraInputsFlake = ./dev;
      module = ./dev/flake-module.nix;
    };
  };

  partitionedAttrs = {
    checks = "dev";
    formatter = "dev";
  };
}

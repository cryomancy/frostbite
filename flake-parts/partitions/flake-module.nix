localFlake: {self, ...}: {
  partitions = {
    default = {
      extraInputsFlake = ./default;
      module = ./default/flake-module;
    };
    dev = {
      extraInputsFlake = ./dev;
      module = ./dev/flake-module.nix;
    };
  };

  partitionedAttrs = {
    checks = "dev";
    # ci = "dev";
    formatter = "dev";
  };
}

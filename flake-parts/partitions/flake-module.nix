localFlake: {self, ...}: {
  partitions = {
    dev = {
      extraInputsFlake = ../dev;
      module = ../dev/flake-module.nix;
    };
  };

  partitionedAttrs = {
    #checks = "dev";
    #ci = "dev";
    formatter = "dev";
  };
}

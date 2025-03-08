{
  partitions = {
    dev = {
      module = ./partitions/dev;
      extraInputsFlake = ./partitions/dev;
    };
  };

  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    herculesCI = "dev";
  };
}

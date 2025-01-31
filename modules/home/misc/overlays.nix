scoped: {inputs, ...}: {
  nixpkgs.overlays = [
    inputs.fuyuvim.overlays.default
    inputs.nur.overlays.default
  ];
}

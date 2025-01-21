scoped: {
  inputs,
  system,
}: scoped: {
  pkgs =
    import inputs.nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
    }
    .appendOverlays
    [
      inputs.fuyuvim.overlays.default
      inputs.nur.overlays.default
    ];
}

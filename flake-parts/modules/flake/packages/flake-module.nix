localFlake: {
  self,
  inputs,
  ...
}: {
  perSystem = {
    config,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        #  inputs.fuyuvim.overlays.default
        #  inputs.jeezyvim.overlays.default
        #  inputs.nur.overlays.default
      ];
      config.allowUnfree = true;
    };
  };
}

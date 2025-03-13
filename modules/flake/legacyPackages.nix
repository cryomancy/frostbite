localFlake: {
  inputs,
  config,
  ...
}: {
  perSystem = {system, ...}: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays =
        [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) system;
              config.allowUnfree = true;
            };
            master = import inputs.nixpkgs-master {
              inherit (final) system;
              config.allowUnfree = true;
            };
          })
        ]
        ++ [
          inputs.fuyuvim.overlays.default
          # inputs.nur.overlays.default
        ];
    };
  };
}

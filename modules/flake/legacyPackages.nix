_:
{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      legacyPackages = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
        overlays = [
          (final: _prev: {
            stable = import inputs.nixpkgs-stable {
              inherit (final) system;
              config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
              };
            };
          })
        ]
        ++ [
          inputs.vostok.overlays.default
          inputs.nur.overlays.default
        ];
      };
    };
}

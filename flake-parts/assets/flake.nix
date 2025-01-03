{
  description = "A large repository of assets that are lazily evaluated.";
  inputs = {
    assets.url = "github:TahlonBrahic/assets";
    base16.url = "github:SenchoPens/base16.nix";
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    walls = {
      url = "github:dharmx/walls";
      flake = false;
    };
  };

  # This flake is only used for its inputs.
  outputs = _: {};
}

{
  description = "A large repository of assets that are lazily evaluated.";
  inputs = {
    assets.url = "github:TahlonBrahic/assets";
  };

  # This flake is only used for its inputs.
  outputs = {...}: {};
}

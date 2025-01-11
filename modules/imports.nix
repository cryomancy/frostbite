{
  haumea,
  lib,
  ...
}: {
  nixos = let
    scopedModules =
      haumea.lib.load
      {
        src = ./nixos;
        loader = haumea.lib.loaders.scoped;
      };
  in
    scopedModules;
  home = let
    scopedModules =
      haumea.lib.load
      {
        src = ./home;
        loader = haumea.lib.loaders.scoped;
      };
  in
    scopedModules;
}

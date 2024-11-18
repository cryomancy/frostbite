{inputs}: let
  inherit (inputs.nixpkgs) lib;

  supportedSystems = ["x86_64-linux" "aarch64-linux"];

  forAllSystems = lib.genAttrs supportedSystems;

  arguments = forAllSystems (system: {
    inherit inputs system lib;
    inherit (pkgs.${system}) pkgs;
    inherit (localLib.${system}) localLib;
  });

  systems = forAllSystems (system: import ./${system} arguments.${system})
    |> builtins.attrValues;

  localLib = forAllSystems (system:
    import ../lib {
      inherit inputs system;
      pkgs = pkgs.${system};
    });

  pkgs = forAllSystems (system:
    import inputs.nixpkgs
    {
      inherit system;
      inherit (localLib.${system}.localLib) overlays;
      config.allowUnfree = true;
    });

  formatter = forAllSystems (system: pkgs.${system}.alejandra);

  devShells = forAllSystems (system: import ../shell.nix pkgs.${system});

  nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) systems);

in {inherit formatter devShells nixosConfigurations;}

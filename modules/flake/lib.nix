{inputs, ...}:
let
  inherit (inputs) eris;
in
{
  config = {
    flake = {
        lib =
			  (eris.lib.load
				{
				  src = ../../lib;
				  loader = eris.lib.loaders.scoped;
				}
			  )
			  |>
			  (inputs.nixpkgs.lib.attrsets.mapAttrsRecursiveCond
				(x: builtins.isAttrs x)
				(n: v:
				  { lib =
					{
					  ${ (inputs.nixpkgs.lib.lists.last n) } = v;
					};
				  }
				)
			  )
			  |>
			  inputs.nixpkgs.lib.attrsets.collect (x: x ? lib)
			  |>
			  builtins.map (x: builtins.attrValues x)
			  |>
			  inputs.nixpkgs.lib.lists.flatten
			  |>
			  inputs.nixpkgs.lib.attrsets.mergeAttrsList;
	    };
	  };
}

let
  inputs.fuyuNoKosei.url = "github:TahlonBrahic/fuyu-no-kosei";
in {
  description = "NixOS configuration that follows fuyu-no-kosei.";

  outputs = inputs: import ./outputs {inherit inputs;};

  inherit (inputs.fuyuNoKosei.inputs) inputs;
}

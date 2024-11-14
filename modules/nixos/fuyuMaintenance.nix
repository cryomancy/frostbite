{inputs, ...}: {
  system = {
    stateVersion = "24.11";
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "-L"
      ];
    };
  };
}

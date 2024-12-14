{
  description = "NixOS installer for fuyu-no-kosei, WIP";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ {
    nixpkgs,
    nixos-hardware,
    ...
  }: {
    nixosConfigurations = {
      build = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ({pkgs, ...}: {
            networking.hostName = "build";
            boot.kernelPackages = pkgs.linuxPackages_latest;
          })
        ];
      };
    };
  };
}

{
  description = "NixOS installer for fuyu-no-kosei, WIP";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko";
  };

  # TODO: Call lib.systemTemplate like normal here with options...
  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = {
      build = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.disko.nixosModules.disko
          ({pkgs, ...}: {
            networking.hostName = "build";
            boot.kernelPackages = pkgs.linuxPackages_latest;
            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINn/+0ClH1hC2Tqvahb6oLockr99dLKuK1vo53UHtibF tahlon@TAHLON-LAPTOP"
            ];

            services.openssh = {
              enable = true;
              settings.PermitRootLogin = "yes";
            };
          })
        ];
      };
    };
  };
}

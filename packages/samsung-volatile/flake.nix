{
  description = "Samsung Volatile Kernel Module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs}: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      inherit (pkgs) stdenv lib fetchFromGitHub;
      inherit (pkgs.linuxPackages_latest) kernel;
    in {
      samsung-volatile-module = stdenv.mkDerivation {
        pname = "samsung-volatile";
        version = "1.0";
        passthru.moduleName = "samsung-volatile";

        src = fetchFromGitHub {
          owner = "TahlonBrahic";
          repo = "samsung-volatile";
          rev = "refs/heads/main";
          hash = "sha256-kiqmFDLTP32dVX4NdThARhr2bbDIFKunrcWIOTPMAYU=";
        };

        hardeningDisable = ["pic" "format"];
        nativeBuildInputs = kernel.moduleBuildDependencies;

        makeFlags =
          kernel.makeFlags
          ++ [
            "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
          ];

        installPhase = ''
          runHook preInstall
          install -D samsung-volatile.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
          runHook postInstall
        '';

        enableParallelBuilding = true;

        meta = {
          description = "A modified samsung-laptop kernel module that can boot from EFI systems";
          homepage = "https://github.com/TahlonBrahic/samsung-volatile";
          license = lib.licenses.gpl2;
          maintainers = with lib.maintainers; [TahlonBrahic];
          platforms = lib.platforms.linux;
        };
      };
    };
  };
}

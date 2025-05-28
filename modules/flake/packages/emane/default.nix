{
  lib,
  stdenv,
  fetchgithub,
  meson, # (>= 0.60.0)
  scdoc,
}:
stdenv.mkDerivation rec {
  pname = "emane";
  version = "0.9";

  src = fetchgithub {
    url = "https://github.com/J-Lentz/iwgtk/archive/refs/tags/v0.9.tar.gz";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = [
    meson
    scdoc
  ];

  unpackPhase = ''
    tar -xzf iwgtk.tar.gz
  '';

  buildPhase = ''
    meson setup build
    cd build
    meson compile
    sudo meson install
  '';

  installPhase = ''
    cp ./. ./$out
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/J-Lentz/iwgtk";
    description = "Lightweight wireless networking GUI (front-end for iwd)";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      tahlonbrahic
    ];
  };
}

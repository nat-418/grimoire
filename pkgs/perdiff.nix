{ lib, tcl, tcllib }:

tcl.mkTclDerivation rec {
  pname   = "perdiff";
  version = "0.1.0";

  src = ../src/perdiff.tcl;

  buildInputs = [
    tcllib
  ];

  dontUnpack    = true;
  dontBuild     = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -pv $out/bin
    install -m 755 $src $out/bin/perdiff
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "Calculate the percent differences between two numbers";
    mainProgram = "perdiff";
    license     = licenses.bsd0;
    platforms   = platforms.all;
  };
}

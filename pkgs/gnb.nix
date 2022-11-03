{ lib, stdenv, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "gnb";
  version = "0.2.0";

  src = ../src/gnb.tcl;

  buildInputs = [
    tcl
    tcllib
  ];

  dontUnpack    = true;
  dontBuild     = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -pv $out/bin
    install -m 755 $src $out/bin/gnb
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "A command-line git notebook";
    mainProgram = "gnb";
    license     = licenses.bsd0;
    platforms   = platforms.all;
  };
}

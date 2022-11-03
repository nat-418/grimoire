{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "gnb";
  version = "0.2.0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
    sha256 = "sha256-7OBdEI3YOXyK3DQLKXW6wdax8beolSb0uIC8M6PZypA=";
  };

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

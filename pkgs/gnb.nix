{ lib, fetchurl, tcl }:

tcl.mkTclDerivation {
  pname   = "gnb";
  version = "0.2.0";

  src = fetchurl "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";

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

{ lib, fetchurl, tcl }:

tcl.mkTclDerivation {
  pname   = "porthogs";
  version = "0.2.0";

  src = fetchurl "https://raw.githubusercontent.com/nat-418/grimoire/main/src/porthogs.tcl";

  dontUnpack    = true;
  dontBuild     = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -pv $out/bin
    install -m 755 $src $out/bin/porthogs
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "Find which processes are hogging what ports, and optionally kill them.";
    mainProgram = "porthogs";
    license     = licenses.bsd0;
    platforms   = platforms.all;
  };
}

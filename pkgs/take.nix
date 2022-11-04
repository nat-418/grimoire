{ lib, tcl }:

tcl.mkTclDerivation rec {
  pname   = "take";
  version = "0.1.1";

  src = ../src/take.tcl;

  dontUnpack    = true;
  dontBuild     = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -pv $out/bin
    install -m 755 $src $out/bin/take
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "A simple task-runner";
    mainProgram = "take";
    license     = licenses.bsd0;
    platforms   = platforms.all;
  };
}

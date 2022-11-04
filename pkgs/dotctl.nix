{ lib, tcl }:

tcl.mkTclDerivation rec {
  pname   = "dotctl";
  version = "0.1.0";

  src = ../src/dotctl.tcl;

  dontUnpack    = true;
  dontBuild     = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -pv $out/bin
    install -m 755 $src $out/bin/dotctl
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "A git wrapper to manage configuration files in a bare repository";
    mainProgram = "dotctl";
    license     = licenses.bsd0;
    platforms   = platforms.all;
  };
}

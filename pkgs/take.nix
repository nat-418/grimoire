{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "take";
  version = "0.1.1";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/take.tcl";
    sha256 = "sha256-YAA1rsII5XnwwCg9KFCbhyUYe31odDGZgEu6H3SQBF8=";
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

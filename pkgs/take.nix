{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "take";
  version = "0.1.0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/take.tcl";
    sha256 = "sha256-7+sno+61usprxMtP9J8AvjIkB+tmUCqSka+VGbfOivs=";
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
    maintainers = [ maintainers.nat-418 ];
  };
}

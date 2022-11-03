{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "perdiff";
  version = "0.1.0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/perdiff.tcl";
    sha256 = "sha256-hFfT7E6d5Qx5qrowGcE8owYmkSXg02D5txV8q06DiWo=";
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

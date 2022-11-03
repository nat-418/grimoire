{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "porthogs";
  version = "0.2.0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/porthogs.tcl";
    sha256 = "sha256-+hjWFKm0KBy7qNVAjxTnLIBDlI0nYjFzvswqaZr09xI=";
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

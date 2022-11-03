{ lib, stdenv, fetchurl, tcl, tcllib, runtimeShell }:

tcl.mkTclDerivation rec {
  pname   = "dotctl";
  version = "0.1.0";

  src = fetchurl {
    url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/dotctl.tcl";
    sha256 = "sha256-ezf6wU4wjau5VcP48tvoM+P2lKcXMolhwnjyr90LFaw=";
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
    install -m 755 $src $out/bin/dotctl
  '';

  meta = with lib; {
    homepage    = "https://github.com/nat-418/grimoire";
    description = "A git wrapper to manage configuration files in a bare repository";
    mainProgram = "dotctl";
    license     = licenses.bsd0;
    platforms   = platforms.all;
    maintainers = [ maintainers.nat-418 ];
  };
}

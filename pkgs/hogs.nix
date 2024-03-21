{ lib, tcl, tcllib, iproute2, fetchFromGitHub, makeWrapper }:

tcl.mkTclDerivation rec {
  pname = "hogs";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "nat-418";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qltysIODN8asFseOirNSOTb5i+LWGZrm0FRkpVAVAL0=";
  };

  buildInputs = [ tcllib ];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = '' 
    mkdir -p $out/bin
    install -m 755 $src/hogs.tcl $out/bin/hogs
  '';
  postFixup = ''
    wrapProgram $out/bin/hogs --set PATH ${lib.makeBinPath [
      iproute2
    ]};
  '';

  meta = with lib; {
    description = " Find the processes hogging your ports.";
    homepage = "https://github.com/nat-418/hogs";
    license = licenses.bsd0;
    changelog = "https://github.com/nat-418/hogs/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ nat-418 ];
    mainProgram = "hogs";
    platforms = lib.platforms.linux;
  };
}

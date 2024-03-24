{ lib, tcl, git, openssh, fetchFromGitHub, makeWrapper }:

tcl.mkTclDerivation rec {
  pname = "clonetrees";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "nat-418";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8QG2lY1Pswk1sDK10w7ILQRmdxTXmkpAqsVvksQzH/c=";
  };

  buildInputs = [];
  nativeBuildInputs = [ makeWrapper ];
  installPhase = '' 
    mkdir -p $out/bin
    install -m 755 $src/${pname}.tcl $out/bin/${pname}
  '';
  postFixup = ''
    wrapProgram $out/bin/${pname} --set PATH ${lib.makeBinPath [
      git
      openssh
    ]};
  '';

  meta = with lib; {
    description = " Find the processes hogging your ports.";
    homepage = "https://github.com/${owner}/${pname}";
    license = licenses.bsd0;
    changelog = "https://github.com/${owner}/${pname}/blob/${version}/CHANGELOG.md";
    maintainers = with maintainers; [ nat-418 ];
  };
}

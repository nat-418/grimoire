{
  clang,
  fetchgit,
  lib,
  libffi,
  llvm,
  makeWrapper,
  openssl,
  pkg-config,
  readline,
  stdenv
}:

stdenv.mkDerivation {
  pname = "PicoLisp";
  version = "24.4.5";
  src = fetchgit {
    url = "https://git.envs.net/mpech/pil21";
    rev = "4147f54169f096d4f0e2251a62932ba7f615231f";
    sha256 = "sha256-W/r1ZsfHEHsNOialkroTlS8JX8JoHvlQy7pFaZ5Iz/8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ clang libffi llvm openssl pkg-config readline ];
  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    cd ..
    mkdir -p "$out/lib" "$out/bin"
    cp -r . "$out/lib/picolisp/"
    ln -s "$out/lib/picolisp/bin/picolisp" "$out/bin/picolisp"
    ln -s "$out/lib/picolisp/bin/pil" "$out/bin/pil"
    substituteInPlace $out/bin/pil --replace /usr $out
  '';

  meta = with lib; {
    description = "A pragmatic programming language.";
    homepage = "https://picolisp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nat-418 ];
    platforms = platforms.all;
  };
}


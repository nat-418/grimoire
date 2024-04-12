{
  fetchgit,
  lib,
  stdenv,
  writeScriptBin
}:

stdenv.mkDerivation rec {
  pname = "MiniPicoLisp";
  version = "2018-09-30";
  src = fetchgit {
    url = "https://github.com/nat-418/miniPicoLisp";
    rev = version;
    sha256 = "sha256-NwZX3mJIQ8hUm5M2P7vE97W1+x8cykw5e6oXQn84Ivs=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ ];
  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    cd ..
    mkdir -p "$out/lib" "$out/bin" 
    cp -r . "$out/lib/minipicolisp/"
    ln -s "$out/lib/minipicolisp/bin/picolisp" "$out/bin/minipicolisp"
    cat <<EOF > mpil
    exec $out/bin/minipicolisp $out/lib/minipicolisp/lib.l @lib/misc.l "\$@"
    EOF
    install mpil "$out/bin/mpil"
  '';

  meta = with lib; {
    description = "An embeddable, 'pure' PicoLisp.";
    homepage = "https://picolisp.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ nat-418 ];
    platforms = platforms.all;
  };
}


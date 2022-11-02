with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "grimoire";
  buildInputs = [
    git
    lsof
    tcl
    tcllib
  ];
}


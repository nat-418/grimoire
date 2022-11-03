{ pkgs ? import <nixpkgs> {}
, grimoire ? (
  with pkgs;

  let
    packages = rec {
      gnb = callPackage ./pkgs/gnb.nix {};

      inherit pkgs;
    };
  in
    packages
)}:

grimoire.pkgs.mkShell rec {
  buildInputs = [
    pkgs.tcl
    pkgs.tcllib
    grimoire.gnb
  ];
}

{ nixpkgs ? import <nixpkgs> {}, grimoire ? import ./default.nix {} }:

nixpkgs.mkShell {
  buildInputs = [
    grimoire.gnb
    grimoire.dotctl
    grimoire.perdiff
    grimoire.porthogs
    grimoire.take
    nixpkgs.git
  ];
}

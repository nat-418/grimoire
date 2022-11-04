{ pkgs ? import <nixpkgs> {}, grimoire ? import ./default.nix {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    grimoire.dotctl
    grimoire.gnb
    grimoire.perdiff
    grimoire.porthogs
    grimoire.take
  ];
}

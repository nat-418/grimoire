{ grimoire ? import ./default.nix {} }:

with grimoire;

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

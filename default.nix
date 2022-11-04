{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  grimoire = {
    dotctl   = nixpkgs.callPackage ./pkgs/dotctl.nix   {};
    gnb      = nixpkgs.callPackage ./pkgs/gnb.nix      {};
    perdiff  = nixpkgs.callPackage ./pkgs/perdiff.nix  {};
    porthogs = nixpkgs.callPackage ./pkgs/porthogs.nix {};
    take     = nixpkgs.callPackage ./pkgs/take.nix     {};
    
    inherit nixpkgs;
  };
in
  grimoire

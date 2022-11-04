{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  grimoire = {
    dotctl   = pkgs.callPackage ./pkgs/dotctl.nix   {};
    gnb      = pkgs.callPackage ./pkgs/gnb.nix      {};
    perdiff  = pkgs.callPackage ./pkgs/perdiff.nix  {};
    porthogs = pkgs.callPackage ./pkgs/porthogs.nix {};
    take     = pkgs.callPackage ./pkgs/take.nix     {};
  };
in
  grimoire 

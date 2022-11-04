{ system ? builtins.currentSystem }:

let
  pkgs = import <nixpkgs> { inherit system; };
  grimoire = with pkgs; {
    dotctl   = callPackage ./pkgs/dotctl.nix   {};
    gnb      = callPackage ./pkgs/gnb.nix      {};
    perdiff  = callPackage ./pkgs/perdiff.nix  {};
    porthogs = callPackage ./pkgs/porthogs.nix {};
    take     = callPackage ./pkgs/take.nix     {};
  };
in
  grimoire 

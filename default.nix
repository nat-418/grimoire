{ system ? builtins.currentSystem }:

let
  nixpkgs = import <nixpkgs> { inherit system; };
  source = path: nixpkgs.callPackage path {};
  grimoire = {
    dotctl   = source ./pkgs/dotctl.nix;
    gnb      = source ./pkgs/gnb.nix;
    perdiff  = source ./pkgs/perdiff.nix;
    porthogs = source ./pkgs/porthogs.nix;
    take     = source ./pkgs/take.nix;
  };
in
  grimoire

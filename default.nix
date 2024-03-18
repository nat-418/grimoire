{ pkgs ? import <nixpkgs> {} }:

{
  knock = pkgs.callPackage ./pkgs/knock.nix {};
}


{ pkgs ? import <nixpkgs> {} }:

{
  clonetrees = pkgs.callPackage ./pkgs/clonetrees.nix {};
  hogs = pkgs.callPackage ./pkgs/hogs.nix {};
  knock = pkgs.callPackage ./pkgs/knock.nix {};
  picolisp = pkgs.callPackage ./pkgs/picolisp.nix {};
}

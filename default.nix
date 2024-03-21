{ pkgs ? import <nixpkgs> {} }:

{
  hogs = pkgs.callPackage ./pkgs/hogs.nix {};
  knock = pkgs.callPackage ./pkgs/knock.nix {};
}

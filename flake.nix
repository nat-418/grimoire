{
  description = "Package for the command-line git notebook.";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
          packages = flake-utils.lib.flattenTree {
            gnb = pkgs.stdenv.mkDerivation {
              pname   = "gnb";
              version = "0.2.0";

              src = pkgs.fetchurl {
                url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
                sha256 = "6957bad55a73645297d1b5032ed8638c3f8641648d5efd47afccd9664834c8aa";
              };

              buildInputs = [
                pkgs.git
                pkgs.tcl
              ];

              dontUnpack    = true;
              dontBuild     = true;
              dontConfigure = true;

              installPhase = ''
                mkdir -pv $out/bin
                install -m 755 $src $out/bin/gnb
              '';
          };
        };

        packages.default = packages.gnb;

        apps.gnb = flake-utils.lib.mkApp { drv = packages.gnb; };

        apps.default = apps.gnb;
      }
    );
}

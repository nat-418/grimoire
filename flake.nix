{
  description = "Package for the command-line git notebook.";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    custom = {
  };

  outputs = { self, nixpkgs, flake-utils, simpleTcl }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        simpleTcl = { pkgs, name, version, description, url, sha256, deps }:
          pkgs.stdenv.mkDerivation {
            pname   = name;
            version = version;

            src = pkgs.fetchurl {
              url    = url;
              sha256 = sha256;
            };

            buildInputs = deps;

            dontUnpack    = true;
            dontBuild     = true;
            dontConfigure = true;

            installPhase = ''
              mkdir -pv $out/bin
              install -m 755 $src $out/bin/${name}
            '';
          };
      in rec {
        packages.gnb = simpleTcl({
          pkgs = pkgs;
          name = "gnb";
          version = "0.2.0";
          description = "A command-line git-powered notebook";
          url = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
          sha256 = "6957bad55a73645297d1b5032ed8638c3f8641648d5efd47afccd9664834c8aa";
          deps = [
            pkgs.git
            pkgs.tcl
          ];
        });
        packages.default = packages.gnb;

        apps.gnb = flake-utils.lib.mkApp { drv = packages.gnb; };

        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.git
            pkgs.tcl
            pkgs.tcllib
          ];
        };
      }
    );
  };
}

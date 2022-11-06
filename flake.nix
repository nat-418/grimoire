{
  description = "Package for the command-line git notebook.";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in let tclScript = { name, version, description, url, sha256, deps }:
          pkgs.stdenv.mkDerivation {
            pname   = name;
            version = version;

            src = pkgs.fetchurl {
              url    = url;
              sha256 = sha256;
            };

            runtimeDependencies = [ pkgs.tcl ] ++ deps;

            dontUnpack    = true;
            dontBuild     = true;
            dontConfigure = true;

            installPhase = ''
              mkdir -pv $out/bin
              install -m 755 $src $out/bin/${name}
            '';
          };
      in rec {
        packages.dotctl = (tclScript {
          name        = "dotctl";
          version     = "0.1.0";
          description = "A git wrapper for managing dotfiles in a bare repository";
          url         = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/dotctl.tcl";
          sha256      = "sha256-ezf6wU4wjau5VcP48tvoM+P2lKcXMolhwnjyr90LFaw=";
          deps        = [ pkgs.git ];
        });
        packages.gnb = (tclScript {
          name        = "gnb";
          version     = "0.2.0";
          description = "A git-powered notebook";
          url         = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
          sha256      = "sha256-aVe61VpzZFKX0bUDLthjjD+GQWSNXv1Hr8zZZkg0yKo=";
          deps        = [ pkgs.git ];
        });
        packages.perdiff = (tclScript {
          name        = "perdiff";
          version     = "0.1.0";
          description = "A percent difference calculator";
          url         = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/perdiff.tcl";
          sha256      = "sha256-la8r3kgmntDJwAq/Jfp3T64Qw3X+WObCU+BR8OP9wGI=";
          deps        = [ pkgs.tcllib ];
        });
        packages.porthogs = (tclScript {
          name        = "porthogs";
          version     = "1.1.0";
          description = "Find which processes are hogging what ports";
          url         = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/porthogs.tcl";
          sha256      = "sha256-+hjWFKm0KBy7qNVAjxTnLIBDlI0nYjFzvswqaZr09xI=";
          deps        = [ pkgs.lsof ];
        });
        packages.take = (tclScript {
          name        = "take";
          version     = "0.1.1";
          description = "A simple task-runner";
          url         = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/take.tcl";
          sha256      = "sha256-YAA1rsII5XnwwCg9KFCbhyUYe31odDGZgEu6H3SQBF8=";
          deps        = [];
        });
        packages.default = packages.gnb;

        apps.gnb      = flake-utils.lib.mkApp { drv = packages.gnb; };
        apps.dotctl   = flake-utils.lib.mkApp { drv = packages.dotctl; };
        apps.perdiff  = flake-utils.lib.mkApp { drv = packages.perdiff; };
        apps.porthogs = flake-utils.lib.mkApp { drv = packages.porthogs; };
        apps.take     = flake-utils.lib.mkApp { drv = packages.take; };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.git
            pkgs.tcl
            pkgs.tcllib
          ];
        };
      }
    );
}

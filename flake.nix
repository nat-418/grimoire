{
  description = "Personal program repository";

  inputs = {
    nixpkgs.url     = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in let tclScript = { name, version, description, dependencies }:
          pkgs.stdenv.mkDerivation {
            pname       = name;
            version     = version;
            meta.description = description;

            src = pkgs.fetchgit {
              url         = "https://github.com/nat-418/grimoire";
              rev         = "fd07109de875b0aec8e53e27bd4b96e6c599f63c";
              sha256      = "sha256-jk02G8fUBr4D04H7k03J+lDg+B/Bww9KNeF/Tp7MMOA=";
            };

            runtimeDependencies = [ pkgs.tcl ] ++ dependencies;

            dontUnpack    = true;
            dontBuild     = true;
            dontConfigure = true;

            installPhase = ''
              mkdir -pv $out/bin
              install -m 755 $src/src/${name}.tcl $out/bin/${name}
            '';
          };
      in rec {
        packages.dotctl = (tclScript {
          name         = "dotctl";
          version      = "0.1.0";
          description  = "A git wrapper for managing dotfiles in a bare repository";
          dependencies = [ pkgs.git ];
        });
        packages.gnb = (tclScript {
          name         = "gnb";
          version      = "0.2.0";
          description  = "A git-powered notebook";
          dependencies = [ pkgs.git ];
        });
        packages.perdiff = (tclScript {
          name         = "perdiff";
          version      = "0.1.0";
          description  = "A percent difference calculator";
          dependencies = [ pkgs.tcllib ];
        });
        packages.porthogs = (tclScript {
          name         = "porthogs";
          version      = "1.1.0";
          description  = "A tool to find and/or kill processes by port number";
          dependencies = [ pkgs.lsof ];
        });
        packages.take = (tclScript {
          name         = "take";
          version      = "0.1.1";
          description  = "A simple task-runner";
          dependencies = [];
        });

        apps.dotctl   = flake-utils.lib.mkApp { drv = packages.dotctl; };
        apps.gnb      = flake-utils.lib.mkApp { drv = packages.gnb; };
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

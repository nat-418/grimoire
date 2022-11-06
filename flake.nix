{
  description = "Package for the command-line git notebook.";

  inputs = { nixpkgs }: {
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  };

  outputs = { self, pkgs }: {
    packages.x86_64-linux.gnb = 
      pkgs.stdenv.mkDerivation {
        pname   = "gnb";
        version = "0.2.0";

        src = pkgs.fetchurl {
          url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
          sha256 = "6957bad55a73645297d1b5032ed8638c3f8641648d5efd47afccd9664834c8aa";
        };

        nativeBuildInputs = [
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

    packages.x86_64-linux.default = self.packages.x86_64-linux.gnb;
  };
}

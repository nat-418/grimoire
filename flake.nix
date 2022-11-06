{
  description = "Programs written by and for me";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.gnb = nixpkgs.stdenv.mkDerivation {
        pname   = "gnb";
        version = "0.2.0";
        description = "A command-line git notebook";
    

        src = nixpkgs.fetchurl {
          url    = "https://raw.githubusercontent.com/nat-418/grimoire/main/src/gnb.tcl";
          sha256 = "6957bad55a73645297d1b5032ed8638c3f8641648d5efd47afccd9664834c8aa";
        };

        nativeBuildInputs = [
          nixpkgs.git
          nixpkgs.tcl
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
}

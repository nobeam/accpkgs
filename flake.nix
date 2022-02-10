{
  description = "A collection of accelerator physics packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system}; {
      packages = {
        tracy = stdenv.mkDerivation rec {
          pname = "tracy";
          version = "3.5";

          buildInputs = [
            automake
            autoconf
            gfortran
          ];

          src = fetchFromGitHub {
            owner = "jbengtsson";
            repo = "tracy-3.5";
            rev = "b4a47421a3f15bd00975011f9fc19deb32f424a2";
            sha256 = "+LF80LECAZaPPeAX1dRKKuzLMtKfeVIBffBL0HwYyjU=";
          };
          prePatch = ''
            rm config/ltmain.sh
          '';
          preConfigure = ''
            ./bootstrap
          '';
          meta = with lib; {
            description = "Self-Consistent charged particle beam dynamics model based on a Symplectic Integrator.";
            homepage = "https://github.com/jbengtsson/tracy-3.5";
          };
        };
        epics = {
          defns_rpn = fetchurl {
            url = https://ops.aps.anl.gov/downloads/defns.rpn;
            sha256 = "62fadae99cef2c18d51be8a68c3012099a773c3a757323e5b7565344cd3ae358";
          };
          base = mkDerivation {
            src = fetchurl
              {
                url = https://ops.aps.anl.gov/downloads/epics.base.configure.tar.gz;
                sha256 = "62fadae99cef2c18d51be8a68c3012099a773c3a757323e5b7565344cd3ae358";
              };
          };
        };
      };
    });
}

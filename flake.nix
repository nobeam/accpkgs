{
  description = "A collection of accelerator physics packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system}; {
      devShells = {
        elegant =
          (pkgs.buildFHSUserEnv {
            name = "elegant-builder";
            targetPkgs = pkgs:
              (with pkgs; [
                gcc
                bintools
                zlib.dev
                readline
                gsl
                lesstif
                openblas.dev
                gfortran
                # (stdenv.lib.getLib gfortran.cc)
              ]) ++ (with pkgs.xorg;
              [
                libX11.dev
                xorgproto
                libXt.dev
                libSM.dev
                libICE.dev
                libXmu.dev
              ]);
            runScript = "bash";
            profile = ''
              export HOST_ARCH="linux-x86_64"
              export EPICS_HOST_ARCH="linux-x86_64"
              export NIX_LDFLAGS="$NIX_LDFLAGS -L${gfortran.cc.lib}/lib"
            '';
          }).env // { };
      };
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
          elegant = stdenv.mkDerivation {
            name = "elegant";
            buildInputs = [ gcc perl ];
            # nativeBuildInputs = [ breakpointHook ];
            sourceRoot = ".";
            HOST_ARCH = "linux-x86_64";
            EPICS_HOST_ARCH = "linux-x86_64";
            srcs = [
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/epics.base.configure.tar.gz;
                sha256 = "wn5DJRoqcUZMbrZY9xOf0/ECLVKxTKjgVTztIkVq0eM=";
              })
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/epics.extensions.configure.tar.gz;
                sha256 = "RtuDv34MxwvmY6gi5MsinLA/UumOaSD7wc4YHfnqxZs=";
              })
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/SDDS.5.1.tar.gz;
                sha256 = "VOUjrQpjrZiu4ez8jnJL7ShOZLKqLpm4d2dqAQORc+I=";
              })
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/oag.apps.config.tar.gz;
                sha256 = "6RyWEYUr5xKv7rcbPQO8nhVy1zCPJa+qheSMvodUbPE=";
              })
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/oag.apps.configure.tar.gz;
                sha256 = "IjdRThRysntZk56KaBNTYX4KZN3KpHfSS7igvk9Qx1g=";
              })
              (fetchurl {
                url = https://ops.aps.anl.gov/downloads/elegant.2021.4.0.tar.gz;
                sha256 = "7Ruobl3TL6FUqIemoGBw1Oc+eSeKCMEtsIMyuhx2EMs=";
              })
            ];
            # fix /usr/gcc error
            # prePatch = ''
            #   substituteInPlace Makefile \
            #   --replace '/usr/bin/xcrun clang' clang
            # '';
            unpackPhase = ''
              mkdir src && cd src
              for src in $srcs; do tar xf $src; done
            '';
            # configurePhase = ''
            buildPhase = ''
              base=`pwd`
              cd $base/epics/base
              make
              cd $base/epics/extensions/configure
              make
              cd $base/epics/extensions/src/SDDS
              make
              cd $base/oag/apps/configure
              make
              cd $base/oag/apps/src/physics 
              make
            '';
          };
        };
      };
    });
}

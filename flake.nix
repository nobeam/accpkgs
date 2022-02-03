{
  description = "A collection of accelerator physics packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    with nixpkgs.legacyPackages.${system}; {
      packages = {
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

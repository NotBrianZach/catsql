{
  description = "A Nix flake for catsql";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        daff = pkgs.callPackage ./daff.nix {};
        catsqlPythonPackage = pkgs.python3Packages.buildPythonPackage {
          pname = "catsql";
          version = "0.4.6";
          src = pkgs.python3Packages.fetchPypi {
            pname = "catsql";
            version = "0.4.6";
            sha256 = "sha256-Lz26EyPk7N7hzFG6dIQq4TdRfSPfa2O6fCWLs6RTgjI=";
          };
          # propagatedBuildInputs = with pkgs.python3Packages; [
# daff

          propagatedBuildInputs = with pkgs.python3Packages; [
            daff
            openpyxl six sqlalchemy parsedatetime
          ] ++ lib.optional (lib.versionAtLeast pkgs.python3.version "3") unicodecsv;
          # checkInputs = with pkgs.python3Packages; [ mock nose ];
          # checkPhase = "nosetests";
        };
      in
      {
        packages.catsql = catsqlPythonPackage;
        defaultPackage = catsqlPythonPackage;
      }
    );
}

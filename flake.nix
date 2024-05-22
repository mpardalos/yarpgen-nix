{
  description = "Yet Another Random Program Generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    yarpgen-src = {
      type = "github";
      owner = "intel";
      repo = "yarpgen";
      rev = "0bfbe4ff734e709ca65c03eb461a5a235402505f";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, yarpgen-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = if builtins.hasAttr "packages" nixpkgs then
          nixpkgs.packages.${system}
        else
          (if builtins.hasAttr "legacyPackages" nixpkgs then
            nixpkgs.legacyPackages.${system}
          else
            nixpkgs);
      in {
        packages.yarpgen = pkgs.stdenv.mkDerivation {
          pname = "yarpgen";
          version = "0bfbe4f";
          src = yarpgen-src;
          buildInputs = [ pkgs.cmake pkgs.git ];
          configurePhase = ''
            cmake .
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp yarpgen $out/bin/yarpgen
          '';
        };
      });

}

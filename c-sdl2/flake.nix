{
  description = "Sample project";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        deps = with pkgs; [
          gcc
          pkg-config
          SDL2
        ];
      in
      {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "sdl2-test";
          src = ./.;
          buildInputs = deps; 
          buildPhase = ''
            gcc -o sdl2-test main.c $(pkg-config --cflags --libs sdl2)
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp sdl2-test $out/bin
          '';
        };
        devShell = pkgs.mkShell {
          programs = deps;
        };
      }
    );
}

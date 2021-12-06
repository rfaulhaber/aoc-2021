{
  description = "Advent of Code 2021 code environment.";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    # NOTE: this might only work in Linux!
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = with pkgs; [
            # C
            clang
            check
            gdb

            racket # Racket
            ghc # Haskell
            ocaml # OCaml
            gforth # Forth
            julia-bin # Julia
            clisp # Common Lisp
            elixir # Elixir
          ];
        };
      });
}

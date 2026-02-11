# This does technically work, but it is easier to use Google Colab

{
  description = "A development environment for the Slope Field Generator";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          # These ones are needed for it to work
          ipython
          notebook
          ipykernel 

          # These ones are just libraries that you can use in python
          numpy
          matplotlib
          sympy
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];

          shellHook = ''
            echo "Environment Loaded."
            echo "To use this in a notebook, run:"
            echo "python -m ipykernel install --user --name=slope-field-kernel --display-name 'Python (Slope Field Nix)'"
          '';
        };
      });
}
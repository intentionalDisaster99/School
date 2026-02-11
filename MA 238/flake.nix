{
  description = "A development environment for the Slope Field Generator";

  inputs = {
    # Using a stable nixpkgs release
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        # Define the python environment with required packages
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          numpy
          matplotlib
          sympy
          ipython # Useful for interactive work
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pythonEnv ];

          # Optional: Shell hook to provide a nice welcome message
          shellHook = ''
            echo "Slope Field Generator Environment Loaded"
            echo "Python version: $(python --version)"
          '';
        };
      });
}
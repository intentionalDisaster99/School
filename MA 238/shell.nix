
# Run nix-shell --command "jupyter lab"
# It takes a second the first time
# Then you just paste the interpreter url (outputted after the command) into the box that appears when 
# you try to run the code in a notebook

let
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "10d64ee254050de69d0dc51c9c39fdadf1398c38";
  }) {};

  # Uncomment this if you want to use haskell
  # ihaskell = jupyter.kernels.iHaskellWith {
  #   name = "haskell";
  #   packages = p: with p; [ hvega formatting ];
  # };

  ipython = jupyter.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ 
      numpy
      sympy
      matplotlib 
    ];
  };

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [  
      # ihaskell # Again, uncomment for Haskell
      ipython 
    ];
  };
in
  jupyterEnvironment.env
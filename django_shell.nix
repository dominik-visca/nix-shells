with (import <nixpkgs> {});

let
  # Import mach-nix for building python enviroments without relying on nixpkgs
  mach-nix = import (
    builtins.fetchGit {
      url = "https://github.com/DavHau/mach-nix/";
      ref = "master";
    }
    ) {
    # Use current pypi db
    pypiDataRev = "1affc081505d1fd5de398dc8e0fbc30b0728153f"; # 2021-11-15T08:14:34Z
    pypiDataSha256 = "1849a8cc16b0hx6xrw7vcccgml2sgavgqszd7jvl7jxs6czzrzkv";
  };

  # Declare python packages to include
  pyEnv = mach-nix.mkPython rec {
    requirements = ''
      Django==3.2.8
      django-tailwind==2.2.2
      pandas==1.3.3
    '';
  };
in
  # Create an insolated shell with node.js and the built python environment
  mach-nix.nixpkgs.mkShell {
    buildInputs = [
      pyEnv
      nodejs-16_x
    ];

    # Install node dependencies
    shellHook = ''
      npm install
    '';
  }


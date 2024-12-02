{
  inputs = {
    check-directory-structure = {
      url = "github:pbizopoulos/check-directory-structure?dir=python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    check-directory-structure,
    flake-parts,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem = {system, ...}: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.http-server
              pkgs.openssl
            ];
          };
        };
        treefmt = {
          programs = {
            alejandra.enable = true;
            biome.enable = true;
            deadnix.enable = true;
            prettier.enable = true;
            statix.enable = true;
          };
          projectRootFile = "flake.nix";
          settings = {
            formatter = {
              biome = {
                options = ["check" "--unsafe"];
                includes = ["script.js" "style.css"];
              };
              check-directory-structure = {
                command = check-directory-structure.packages.${system}.default;
                includes = ["."];
              };
              prettier = {
                options = ["--print-width" "999"];
                includes = ["index.html"];
              };
            };
            global.excludes = ["prm/**" "pyscript/**" "python/**" "tmp/**"];
          };
        };
      };
      flake.templates.default = {
        description = "";
        path = ./.;
      };
    };
}

{
  inputs = {
    devour-flake = {
      flake = false;
      url = "github:srid/devour-flake";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pbizopoulos-github-io = {
      url = "github:pbizopoulos/pbizopoulos.github.io";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    flake-parts,
    pbizopoulos-github-io,
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
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells = {
          docs = pkgs.mkShell {
            buildInputs = [
              pkgs.http-server
            ];
          };
        };
        packages = {
          build-all = let
            devour-flake = pkgs.callPackage inputs.devour-flake {};
          in
            pkgs.writeShellApplication {
              name = "build-all";
              runtimeInputs = [
                pkgs.nix
                devour-flake
              ];
              text = ''
                nix flake lock --no-update-lock-file
                devour-flake . "$@"
              '';
            };
        };
        treefmt = {
          programs = {
            actionlint.enable = true;
            alejandra.enable = true;
            biome.enable = true;
            deadnix.enable = true;
            prettier.enable = true;
            statix.enable = true;
            yamlfmt.enable = true;
          };
          projectRootFile = "flake.nix";
          settings = {
            formatter = {
              actionlint = {
                includes = [".github/workflows/workflow.yml"];
              };
              biome = {
                options = ["check" "--unsafe"];
                includes = ["script.js" "style.css"];
              };
              check-directory = {
                command = pbizopoulos-github-io.packages.${system}.check-directory;
                includes = ["."];
              };
              check-readme = {
                command = pbizopoulos-github-io.packages.${system}.check-readme;
                includes = ["README"];
              };
              prettier = {
                options = ["--print-width" "999"];
                includes = ["index.html"];
              };
              yamlfmt = {
                includes = [".github/workflows/workflow.yml"];
              };
            };
            global.excludes = ["prm/**" "tmp/**"];
          };
        };
      };
      flake.templates.default = {
        description = "";
        path = ./.;
      };
    };
}

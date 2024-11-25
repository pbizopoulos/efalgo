{
  inputs = {
    check-readme = {
      url = "github:pbizopoulos/check-readme?dir=python";
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
    self,
    nixpkgs,
    flake-parts,
    treefmt-nix,
    check-readme,
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
          config.allowUnfree = true;
        };
      in {
        devShells = {
          all = pkgs.mkShell {
            shellHook = ''
              set -e
              exit
            '';
          };
          default = pkgs.mkShell {};
        };
        treefmt = {
          projectRootFile = "flake.nix";
          settings.global.excludes = ["docs/**" "latex/**" "nix/**" "python/**" "tmp/**"];
          programs = {
            # deadnix.enable = true;
            alejandra.enable = true;
          };
          settings.formatter = {
            actionlint = {
              command = pkgs.actionlint;
              includes = [".github/workflows/workflow.yml"];
            };
            check-readme = {
              command = check-readme.packages.${system}.default;
              includes = ["README"];
            };
            shellcheck = {
              command = pkgs.shellcheck;
              includes = ["deploy.sh" "deploy-requirements.sh"];
            };
            shfmt = {
              command = pkgs.shfmt;
              includes = ["deploy.sh" "deploy-requirements.sh"];
              options = ["--posix" "--write"];
            };
            yamlfmt = {
              command = pkgs.yamlfmt;
              includes = [".github/workflows/workflow.yml"];
            };
            mypy = {
              command = pkgs.python311Packages.mypy;
              includes = ["main.py"];
              options = [
                "--cache-dir"
                "tmp/mypy"
                "--ignore-missing-imports"
                "--strict"
              ];
            };
            statix-check = {
              command = pkgs.statix;
              includes = ["*.nix"];
              options = ["check"];
            };
            statix-fix = {
              command = pkgs.statix;
              includes = ["*.nix"];
              options = ["fix"];
            };
          };
        };
      };
    };
}

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
    check-readme,
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
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
          settings.formatter = {
            actionlint = {
              command = pkgs.actionlint;
              includes = [".github/workflows/workflow.yml"];
            };
            check-directory = {
              command = pkgs.bash;
              options = [
                "-euc"
                ''
                  if ls -ap | grep -v -E -x './|../|.env|.git/|.github/|.gitignore|CITATION.bib|LICENSE|Makefile|README|deploy.sh|deploy-requirements.sh|docs/|flake.lock|flake.nix|latex/|nix/|python/|tmp/' | grep -q .; then exit 1; fi
                  if printf "$(basename $(pwd))" | grep -v -E -x '^[a-z0-9]+([-.][a-z0-9]+)*$'; then false; fi
                ''
                "--"
              ];
              includes = ["**"];
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
            tex-fmt = {
              command = pkgs.tex-fmt;
              includes = ["CITATION.bib"];
              options = ["--keep"];
            };
            yamlfmt = {
              command = pkgs.yamlfmt;
              includes = [".github/workflows/workflow.yml"];
            };
          };
        };
      };
      flake.templates.default.path = ./.;
    };
}

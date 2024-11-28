{
  inputs = {
    check-directory-structure = {
      url = "github:pbizopoulos/check-directory-structure?dir=python";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    check-directory-structure,
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
        pkgs = import nixpkgs {inherit system;};
      in {
        treefmt = {
          programs = {
            actionlint.enable = true;
            alejandra.enable = true;
            beautysh.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
            yamlfmt.enable = true;
          };
          projectRootFile = "flake.nix";
          settings = {
            formatter = {
              actionlint = {
                includes = [".github/workflows/workflow.yml"];
              };
              beautysh = {
                includes = ["deploy.sh" "deploy-requirements.sh"];
              };
              check-directory-structure = {
                command = check-directory-structure.packages.${system}.default;
                includes = ["."];
              };
              check-readme = {
                command = check-readme.packages.${system}.default;
                includes = ["README"];
              };
              shellcheck = {
                includes = ["deploy.sh" "deploy-requirements.sh"];
              };
              shfmt = {
                includes = ["deploy.sh" "deploy-requirements.sh"];
                options = ["--posix" "--write"];
              };
              tex-fmt = {
                command = pkgs.tex-fmt;
                includes = ["CITATION.bib"];
                options = ["--keep"];
              };
              yamlfmt = {
                includes = [".github/workflows/workflow.yml"];
              };
            };
            global.excludes = ["docs/**" "latex/**" "nix/**" "python/**" "tmp/**"];
          };
        };
      };
      flake.templates.default = {
        description = "";
        path = ./.;
      };
    };
}

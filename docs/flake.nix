{
  inputs = {
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
        dependencies = [
          pkgs.http-server
          pkgs.openssl
        ];
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells = {
          all = pkgs.mkShell {
            buildInputs = dependencies;
            shellHook = ''
              set -e
              if [ -n "$DEBUG" ]; then
                exit 0
              else
                openssl req -keyout tmp/privkey.pem -nodes -out tmp/fullchain.pem -subj '/C=..' -x509
                http-server --cert tmp/fullchain.pem --key tmp/privkey.pem --tls
                exit 1
              fi
            '';
          };
          default = pkgs.mkShell {buildInputs = dependencies;};
        };
        treefmt = {
          projectRootFile = "flake.nix";
          settings.global.excludes = ["prm/**" "pyscript/**" "python/**" "tmp/**"];
          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
          };
          settings.formatter = {
            biome = {
              command = pkgs.biome;
              options = [
                "check"
                "--unsafe"
                "--write"
              ];
              includes = ["script.js"];
            };
            check-directory = {
              command = pkgs.bash;
              options = [
                "-euc"
                ''
                  if ls -ap | grep -v -E -x './|../|.env|.gitignore|CNAME|Makefile|index.html|flake.lock|flake.nix|prm/|pyscript/|python/|script.js|style.css|tmp/' | grep -q .; then exit 1; fi
                  test $(basename $(pwd)) = "docs"
                ''
                "--"
              ];
              includes = ["**"];
            };
            prettier = {
              command = pkgs.nodePackages.prettier;
              options = [
                "--print-width"
                "999"
              ];
              includes = ["index.html"];
            };
            statix-check = {
              command = pkgs.statix;
              includes = ["flake.nix"];
              options = ["check"];
            };
            statix-fix = {
              command = pkgs.statix;
              includes = ["flake.nix"];
              options = ["fix"];
            };
          };
        };
      };
      flake.templates.default.path = ./.;
    };
}

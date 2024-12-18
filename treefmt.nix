{pkgs, ...}: {
  programs = {
    actionlint.enable = true;
    alejandra.enable = true;
    biome.enable = true;
    deadnix.enable = true;
    prettier.enable = true;
    statix.enable = true;
    toml-sort.enable = true;
    yamlfmt.enable = true;
  };
  projectRootFile = "flake.nix";
  settings = {
    formatter = {
      actionlint = {
        includes = [".github/workflows/workflow.yml"];
      };
      bibtex-tidy = {
        command = pkgs.bibtex-tidy;
        includes = ["*/ms.bib"];
        options = ["--duplicates" "--no-align" "--no-wrap" "--sort" "--sort-fields" "--v2"];
      };
      biome = {
        options = ["check" "--unsafe"];
        includes = ["*/script.js" "*/style.css"];
      };
      mypy = {
        command = pkgs.mypy;
        includes = ["*/main.py"];
        options = [
          "--cache-dir"
          "tmp/mypy"
          "--explicit-package-bases"
          "--ignore-missing-imports"
          "--strict"
        ];
      };
      prettier = {
        options = ["--print-width" "999"];
        includes = ["*/index.html"];
      };
      ruff-check = {
        command = pkgs.ruff;
        includes = ["*/main.py"];
        options = ["check" "--cache-dir" "tmp/ruff" "--fix" "--select" "ALL" "--unsafe-fixes"];
      };
      ruff-format = {
        command = pkgs.ruff;
        includes = ["*/main.py"];
        options = ["format" "--cache-dir" "tmp/ruff"];
      };
      tex-fmt = {
        command = pkgs.tex-fmt;
        includes = ["CITATION.bib" "*/ms.bib" "*/ms.tex"];
        options = ["--keep"];
      };
      toml-sort = {
        includes = ["*/pyproject.toml"];
        options = ["--all"];
      };
      yamlfmt = {
        includes = [".github/workflows/workflow.yml"];
      };
    };
    global.excludes = ["prm/**" "tmp/**"];
  };
}

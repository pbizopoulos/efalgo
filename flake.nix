{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pbizopoulos-github-io = {
      url = "github:pbizopoulos/pbizopoulos.github.io";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      outputs-builder = channels: {
        formatter = inputs.pbizopoulos-github-io.formatter.x86_64-linux;
        packages = {
          inherit (inputs.pbizopoulos-github-io.pkgs.${channels.nixpkgs.system}.nixpkgs.internal) build-all-outputs;
        };
      };
    };
}

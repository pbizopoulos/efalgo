{
  inputs = {
    pbizopoulos-github-io = {
      url = "github:pbizopoulos/pbizopoulos.github.io";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      channels-config.allowUnfree = true;
      outputs-builder = channels: {
        formatter = (inputs.treefmt-nix.lib.evalModule channels.nixpkgs ./treefmt.nix).config.build.wrapper;
      };
    };
}

{
  inputs = {
    canonicalize = {
      url = "github:pbizopoulos/canonicalize";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      outputs-builder = _channels: {
        formatter = inputs.canonicalize.formatter.x86_64-linux;
      };
    };
}

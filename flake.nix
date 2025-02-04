{
  inputs = {
    canonicalization = {
      url = "github:pbizopoulos/canonicalization";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;
      outputs-builder = _channels: {
        formatter = inputs.canonicalization.formatter.x86_64-linux;
      };
    };
}

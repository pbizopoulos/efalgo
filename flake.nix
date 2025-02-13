{
  inputs = {
    canonicalization = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pbizopoulos/canonicalization";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    snowfall-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:snowfallorg/lib";
    };
  };
  outputs =
    inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      outputs-builder = _channels: { formatter = inputs.canonicalization.formatter.x86_64-linux; };
      src = ./.;
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, crane, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        buildInputs = with pkgs; [ pkg-config openssl_3 ];

        craneLib = crane.lib.${system};
      in
    {
      packages.default = craneLib.buildPackage {
        inherit buildInputs;

        src = craneLib.cleanCargoSource (craneLib.path ./.);

        # Add extra inputs here or any other derivation settings
        # doCheck = true;
        # nativeBuildInputs = [];
      };

      devShell = pkgs.mkShell {
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;

	buildInputs = with pkgs; buildInputs ++ [ rust-analyzer ];
      };

    });
}

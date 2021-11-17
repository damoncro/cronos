{sources ? import ./sources.nix, pkgs ? import ./default.nix { } }:
pkgs.rustPlatform.buildRustPackage rec {
  name = "hermes";
  src = sources.ibc-rs;
  cargoSha256 = sha256:1sc4m4bshnjv021ic82c3m36pakf15xr5cw0dsrcjzs8pv3nq9cd;
  cargoBuildFlags = "-p ibc-relayer-cli";
  buildInputs = pkgs.lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.Security
    pkgs.darwin.libiconv
  ];
  doCheck = false;
  RUSTFLAGS = "--cfg ossl111 --cfg ossl110 --cfg ossl101";
  OPENSSL_NO_VENDOR = "1";
  OPENSSL_DIR = pkgs.symlinkJoin {
    name = "openssl";
    paths = with pkgs.openssl; [ out dev ];
  };
}

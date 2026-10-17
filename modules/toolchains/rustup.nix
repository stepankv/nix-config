{ pkgs, lib, ... }:

let
  rust-unstable = pkgs.unstable.rustup;
in
{
  home.packages = [ rust-unstable ];

  home.activation = {
    setupRustup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run "${rust-unstable}/bin/rustup" install stable --no-self-update
      run "${rust-unstable}/bin/rustup" default stable
    '';
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}

{ pkgs, lib, ... }:

{
  home.packages = with pkgs.unstable; [
    rustup
  ];

  home.activation = {
    setupRustup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # Avoid implicit updates to make activation
      # run "${pkgs.rustup}/bin/rustup" install stable --no-update --no-self-update
      run "${pkgs.rustup}/bin/rustup" install stable --no-self-update
      run "${pkgs.rustup}/bin/rustup" default stable
    '';
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}

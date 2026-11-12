{ pkgs, ... }:

let
  hiddify = pkgs.appimageTools.wrapType2 {
    pname = "hiddify";
    version = "5.5.5";
    src = pkgs.fetchurl {
      url = "https://github.com/hiddify/hiddify-app/releases/download/v5.5.5/Hiddify-Linux-x64-AppImage.AppImage";
      sha256 = "sha256-0cpIwiqtOMs6UyT8uq2f3aV9dHedBnHffxTJnIXW0EE=";
    };
    extraPkgs =
      pkgs: with pkgs; [
        libepoxy
        zstd
      ];
  };
  hiddifyContents = pkgs.appimageTools.extract {
    inherit (hiddify) pname version src;
  };
in
{
  home.packages = [ hiddify ];

  xdg.desktopEntries.hiddify = {
    name = "Hiddify";
    exec = "${hiddify}/bin/hiddify";
    icon = "${hiddifyContents}/hiddify.png";
    terminal = false;
    categories = [ "Network" ];
    settings = {
      Keywords = "vpn;proxy;";
    };
  };
}

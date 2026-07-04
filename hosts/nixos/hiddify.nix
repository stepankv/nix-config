{ pkgs, ... }:

let
  hiddify = pkgs.appimageTools.wrapType2 {
    pname = "hiddify";
    version = "4.1.1";
    src = pkgs.fetchurl {
      url = "https://github.com/hiddify/hiddify-app/releases/download/v4.1.1/Hiddify-Linux-x64-AppImage.AppImage";
      sha256 = "sha256-6yu2wIlxuY4tCgH8W2R+KboXsWYRScyfl+2g53v1vcM=";
    };
    extraPkgs =
      pkgs: with pkgs; [
        libepoxy
        zstd
      ];
  };
in
{
  environment.systemPackages = [ hiddify ];

  security.wrappers.hiddify = {
    source = "${hiddify}/bin/hiddify";
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin+ep cap_net_raw+ep";
    setuid = false;
    setgid = false;
  };
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # hiddify
  ];

  xdg.desktopEntries.hiddify = {
    name = "Hiddify";
    exec = "/run/wrappers/bin/hiddify";
    icon = "network-vpn";
    terminal = false;
    categories = [ "Network" ];
    settings = {
      Keywords = "vpn;proxy;";
    };
  };
}

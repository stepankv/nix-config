{ station, ... }:

{
  services.xremap = {
    enable = true;
    serviceMode = "user";
    userName = station.username;
    withGnome = true;
    extraArgs = [ "--watch=device" ];
    yamlConfig = builtins.readFile ./xremap.yml;
  };
}

{
  networking = {
    hostName = "x-ams-01";
    useDHCP = false;
    useNetworkd = true;
  };

  services.resolved.enable = true;

  systemd.network.networks."10-avm" = {
    matchConfig.MACAddress = "52:54:00:f4:3a:fa";
    linkConfig.RequiredForOnline = "no";
    address = [
      "193.33.153.176/32"
      "2a0b:4140:8bda::2/48"
    ];
    networkConfig = {
      DHCP = "no";
      IPv6AcceptRA = false;
      IPv6PrivacyExtensions = false;
      KeepConfiguration = "no";
      LinkLocalAddressing = "ipv6";
    };
    dns = [
      "1.1.1.1"
      "8.8.8.8"
      "2606:4700:4700::1111"
      "2001:4860:4860::8888"
    ];
    routes = [
      {
        Destination = "0.0.0.0/0";
        Gateway = "10.0.0.1";
        # The provider routes this /32 through an off-subnet gateway.
        GatewayOnLink = true;
      }
      {
        Destination = "::/0";
        Gateway = "2a0b:4140:8bda::1";
        GatewayOnLink = true;
      }
    ];
  };
}

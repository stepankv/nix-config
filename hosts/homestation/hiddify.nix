{ pkgs, station, ... }:

let
  hiddify = pkgs.callPackage ../../packages/hiddify.nix { };
in
{
  environment.systemPackages = [ hiddify ];

  security.polkit.enable = true;
  boot.kernelModules = [ "tun" ];

  # TUN policy routing can send replies through a different interface.
  networking.firewall.checkReversePath = "loose";

  systemd.services.HiddifyAdminBG = {
    description = "Hiddify VPN backend";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = with pkgs; [
      iproute2
      nftables
      systemd
    ];

    preStart = ''
      secret=/var/lib/hiddify-admin-bgservice/control.secret
      if [ ! -s "$secret" ]; then
        umask 077
        ${pkgs.openssl}/bin/openssl rand -base64 48 | tr -d '\n' > "$secret"
      fi
      chown ${station.username}:root "$secret"
      chmod 0600 "$secret"
    '';

    serviceConfig = {
      ExecStart = "${hiddify}/bin/HiddifyCli admin_bgservice run";
      WorkingDirectory = "/var/lib/hiddify-admin-bgservice";
      StateDirectory = "hiddify-admin-bgservice";
      StateDirectoryMode = "0755";
      Restart = "on-failure";
      RestartSec = 2;
      UMask = "0022";
    };
  };
}

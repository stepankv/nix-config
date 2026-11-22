{
  config,
  lib,
  pkgs,
  ...
}:

let
  port = 8082;
  homeConfig = config.home-manager.users.developer;
  subjectAltNames = lib.concatMapStringsSep "," (
    address: "IP:${builtins.head (lib.splitString "/" address)}"
  ) config.systemd.network.networks."10-avm".address;
  prepareCertificate = pkgs.writeShellScript "zellij-web-certificate" ''
    set -eu
    umask 077

    cert="$1/cert.pem"
    key="$1/key.pem"
    if [ ! -s "$key" ] || ! ${pkgs.openssl}/bin/openssl x509 \
      -checkend 604800 -noout -in "$cert" >/dev/null 2>&1; then
      ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:3072 -noenc \
        -days 365 -subj ${lib.escapeShellArg "/CN=${config.networking.hostName}"} \
        -addext ${lib.escapeShellArg "subjectAltName=${subjectAltNames}"} \
        -addext "basicConstraints=critical,CA:FALSE" \
        -addext "extendedKeyUsage=serverAuth" \
        -keyout "$key" -out "$cert"
    fi
  '';
in
{
  networking.firewall.allowedTCPPorts = [ port ];
  users.users.developer.linger = true;

  home-manager.users.developer.systemd.user.services.zellij-web = {
    Unit.Description = "Zellij web terminal";
    Install.WantedBy = [ "default.target" ];
    Service = {
      ExecStartPre = "${prepareCertificate} %S/zellij-web";
      ExecStart = "${pkgs.unstable.zellij}/bin/zellij web --start --ip 0.0.0.0 --port ${toString port} --cert %S/zellij-web/cert.pem --key %S/zellij-web/key.pem";
      WorkingDirectory = homeConfig.home.homeDirectory;
      Environment = [
        "PATH=/run/wrappers/bin:${homeConfig.home.profileDirectory}/bin:/run/current-system/sw/bin"
        "SHELL=${lib.getExe config.users.users.developer.shell}"
        "EDITOR=${homeConfig.home.sessionVariables.EDITOR}"
        "VISUAL=${homeConfig.home.sessionVariables.VISUAL}"
      ];
      StateDirectory = "zellij-web";
      StateDirectoryMode = "0700";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

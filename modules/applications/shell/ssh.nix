{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.ssh;
in
{
  options.my.ssh.device = lib.mkOption {
    type = lib.types.enum [
      "homestation"
      "macos"
    ];
    description = "Device identity used in Bitwarden SSH key names.";
  };

  config = {
    home.packages = with pkgs.unstable; [
      bitwarden-cli
      jq
    ];

    home.sessionVariables.SSH_KEY_PROFILE = cfg.device;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          User = "git";
          IdentityFile = "~/.ssh/github";
          IdentitiesOnly = true;
        };
        "gitlab.com" = {
          User = "git";
          IdentityFile = "~/.ssh/gitlab";
          IdentitiesOnly = true;
        };
      };
    };
  };
}

{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    wget
    eza # better ls
    btop # better htop
    cloc # print project file summary
    lazydocker # docker tui
    just # command runner
  ];

  programs.zsh.shellAliases = {
    ls = "eza --color=always --long --icons=always --no-user --no-time --no-permissions";
    lzd = "lazydocker";
    jt = "just";
  };
}

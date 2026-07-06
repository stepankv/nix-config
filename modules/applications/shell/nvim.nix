{ pkgs, dotfiles-nvim, ... }:

{
  home.packages = with pkgs.unstable; [
    neovim

    xclip # used by Nvim to share OS and Nvim buffers (run `:h clipboard` for details)
    libxml2 # XML formatter
    shellcheck # Shell linter. Used by bash-language-server.
    shfmt # Shell formatter
    stylua # Lua formatter
    yq # YAML file formatter
    jq # JSON file formatter
    tree-sitter # Syntax highlighting
    nixfmt # nix language formatter
    taplo # Toml language formatter

    # Language Servers
    lua-language-server
    bash-language-server
    buf
    yaml-language-server
    vscode-json-languageserver
    just-lsp
    typescript-language-server
    basedpyright
    ruff
    nil # nix language server
  ];

  xdg.configFile."nvim".source = "${dotfiles-nvim}";
}

{ pkgs, ... }:

{
  programs.obsidian = {
    enable = true;
    package = pkgs.unstable.obsidian;
    defaultSettings = {
      corePlugins = [
        "backlink"
        "bookmarks"
        "file-recovery"
        "file-explorer"
        "editor-status"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "switcher"
        "global-search"
        "tag-pane"
        "templates"
        "markdown-importer"
        "properties"
        {
          name = "daily-notes";
          settings = {
            format = "YYYY.MM.DD";
          };
        }
      ];
    };
    vaults = {
      "Documents/obsidian/personal-vault".enable = true;
    };
  };
}

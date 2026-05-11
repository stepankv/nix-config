{ lib, ... }:

{
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        # Switch to dark theme
        color-scheme = "prefer-dark";
        gtk-theme = "Yaru-blue-dark";
        icon-theme = "Yaru-blue";
        cursor-theme = "Yaru";

        # Setup fonts
        # 'font-name' setting is managed by 'gtk.font.name'
        # and conflicts in case if values are different.
        document-font-name = "Adwaita Sans Regular 11";
        monospace-font-name = "JetBrainsMono Nerd Font 11";

        # Disable overview, when drop cursour on sreen adge
        enable-hot-corners = false;
      };

      "org/gnome/desktop/background" = {
        picture-uri-dark = "${./wallpaper.jxl}";
      };

      # Mouse acceleration
      "org/gnome/desktop/peripherals/mouse" = {
        speed = -0.67;
      };

      # ENG & RUS keyboard inputs
      "org/gnome/desktop/input-sources" = {
        sources = [
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "us"
          ])
          (lib.hm.gvariant.mkTuple [
            "xkb"
            "ru"
          ])
        ];
      };

      # File explorer
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
      };
      "org/gnome/nautilus/list-view" = {
        default-zoom-level = "medium";
        default-visible-columns = [
          "size"
          "date_accessed"
          "date_modified"
          "date_created"
        ];
      };
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "small";
      };
      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = true;
      };

      "org/gnome/desktop/wm/preferences" = {
        # Arrangement of buttons on the titlebar
        button-layout = "close:";
      };

      "org/gnome/mutter" = {
        # Disable windows upscale, when drop window on sreen edge
        edge-tiling = false;
      };

      # Enable extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "rounded-window-corners@fxgn"
          "dash-to-dock@micxgx.gmail.com"
        ];
      };

      # Replace default dock panel
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        dash-max-icon-size = 38;
        background-opacity = 0.7;
        show-mounts = false;
        show-trash = true;
        show-mounts-network = true;
        hot-keys = false;
        disable-overview-on-startup = true;
        extend-height = false;
        intellihide = false; # otherwise, dock would hide only when window overlap
      };

      # Desktop icons
      "org/gnome/shell/extensions/ding" = {
        icon-size = "tiny";
        show-home = false;
        start-corner = "top-right";
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Yaru-blue-dark";
    };

    iconTheme = {
      name = "Yaru-blue";
    };

    cursorTheme = {
      name = "Yaru";
    };

    font = {
      name = "Adwaita Sans Regular";
      size = 10;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}

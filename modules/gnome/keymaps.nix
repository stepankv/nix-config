{ ... }:

{
  dconf = {
    enable = true;
    settings = {
      # Keyboard Shortcuts
      "org/gnome/desktop/wm/keybindings" = {
        # switch keyboard language
        switch-input-source = [
          "<Alt>space"
          ":XF86Keyboard"
        ];
        switch-input-source-backward = [
          "<Shift><Alt>space"
          "<Shift>XF86Keyboard"
        ];

        # Window switching
        switch-applications = [ "<Super>Tab" ];
        switch-applications-backward = [ "<Shift><Super>Tab" ];
        switch-group = [ "<Super>Above_Tab" ];
        switch-group-backward = [ "<Shift><Super>Above_Tab" ];
        switch-windows = [ ];
        switch-windows-backward = [ ];

        # Disable workspace switching
        switch-to-workspace-right = [ ];
        switch-to-workspace-left = [ ];
        switch-to-workspace-up = [ ];
        switch-to-workspace-down = [ ];
        move-to-workspace-right = [ ];
        move-to-workspace-left = [ ];
        move-to-workspace-up = [ ];
        move-to-workspace-down = [ ];

        close = [ "<Super>q" ]; # Close window
        minimize = [ "<Super>m" ]; # Hide window
        activate-window-menu = [ ]; # Disable window menu
      };

      "org/gnome/shell/keybindings" = {
        toggle-overview = [ "<Super>space" ]; # Togle application overview & search
      };

      "org/gnome/mutter" = {
        overlay-key = ""; # Disable search application by [Super]
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<Control><Super>q" ]; # Lock screen
      };

      # Allow xremap to fetch the focused application name
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "xremap@k0kubun.com"
        ];
      };
    };
  };
}

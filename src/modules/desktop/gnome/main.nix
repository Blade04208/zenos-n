{ pkgs, ... }:

let
  # Define custom Forge extension from local precompiled resources

  # Define extensions
  extensions = [
  ]
  ++ (with pkgs.gnomeExtensions; [
    user-themes
    # Window Management
    app-hider
    # undecorate
    hide-minimized
    hide-cursor
    burn-my-windows
    rounded-window-corners-reborn
    blur-my-shell

    # UX / Navigation
    alphabetical-app-grid
    category-sorted-app-grid
    coverflow-alt-tab
    #  hide-top-bar
    mouse-tail
    window-is-ready-remover

    # [NEW] Clock Formatting (Modern replacement)
    date-menu-formatter

    # System
    #    gsconnect
    clipboard-indicator
    notification-timeout
    appindicator
    media-controls
    color-picker
  ]);
in
{
  imports = [
    ./styling.nix
  ];

  # [FIX] Portal Configuration
  # This fixes the VS Code freeze and PWA crashes on file picker.
  # We strictly prioritize the GNOME portal.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [
      "gnome"
      "gtk"
    ];
  };

  # 1. Core Desktop Services
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    udev.packages = with pkgs; [ gnome-settings-daemon ];

  };

  # 2. System-wide Packages
  environment = {

    systemPackages =
      with pkgs;
      [
        pipewire
        gst_all_1.gstreamer
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-ugly
        gst_all_1.gst-libav # Essential for common formats like .mp4/.mkv

        gnome-tweaks
        gnome-extension-manager
        wl-clipboard
        dconf-editor
        ptyxis
        resources
        icon-library
        #  nautilus-open-any-terminal
        gnome-builder
      ]
      ++ extensions;

    gnome.excludePackages = (
      with pkgs;
      [
        gnome-software
        gnome-photos
        gnome-tour
        gedit
        cheese
        gnome-music
        gnome-maps
        epiphany
        gnome-contacts
        gnome-weather
        gnome-console
        geary
      ]
    );
  };

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal"
  ];

  # 3. Declarative GSettings (Dconf) for All Users
  programs.dconf = {
    enable = true;
    profiles.user.databases = [
      {
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            enable-hot-corners = false;
            gtk-enable-primary-paste = false;
          };
          "com/github/stunkymonkey/nautilus-open-any-terminal" = {
            enable = true;
            terminal = "ptyxis";
          };

          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = map (ext: ext.extensionUuid) extensions;

            favorite-apps = [
              "firefox.desktop"
              "org.gnome.Nautilus.desktop"
            ];
          };

          # [NEW] Date Menu Formatter Configuration (Matched to user dconf dump)
          "org/gnome/shell/extensions/date-menu-formatter" = {
            pattern = "dd.MM  HH:mm";
            formatter = "01_luxon";
            text-align = "center";
            # [FIX] Explicitly type integers
            font-size = pkgs.lib.gvariant.mkInt32 9;
            update-level = pkgs.lib.gvariant.mkInt32 1;
          };

          # [FIX] Crash Prevention: Disable edge tiling to stop auto-maximize logic
          "org/gnome/desktop/wm/preferences" = {
            edge-tiling = true;
            action-double-click-titlebar = "toggle-maximize";
          };

          # [FIX] UX: Center new windows since we disabled auto-max
          "org/gnome/mutter" = {
            edge-tiling = true;
            center-new-windows = true;
            auto-maximize = false;
            experimental-features = [
              "scale-monitor-framebuffer"
              "xwayland-native-scaling"
            ];
          };
        };
      }
    ];
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ptyxis";
  };
}

{
  pkgs,
  lib,
  ...
}:

{
  services.flatpak = {
    enable = true;

    # Add Flathub (or other remotes) managed declaratively
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      # {
      #     name = "flathub-beta";
      #     location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
      # }
    ];

    # Optional: Auto-update logic (systemd timer)
    update.auto = {
      enable = true;
      onCalendar = "weekly"; # Default is daily
    };

    # Optional: Uninstall Flatpaks not in this list (Strict declarative mode)
    uninstallUnmanaged = true;
  };

  # Make Flatpak apps honour the system font (Atkinson Hyperlegible) instead of
  # falling back to a bundled default. Flatpak sandboxes don't see the host
  # fontconfig or system font directories, so we point them at the NixOS-managed
  # ones via overrides applied to every app.
  services.flatpak.overrides.settings.global = {
    Context.filesystems = [
      "/nix/store:ro"
      "/home/blade0/.themes:ro"
      "/home/blade0/.icons:ro"
      "/home/blade0/.local/share/fonts:ro"
      "/home/blade0/.config/gtk-3.0:ro"
      "/home/blade0/.config/gtk-4.0:ro"
    ];
    Environment = {
      FONTCONFIG_FILE = "/etc/fonts/fonts.conf";
      FONTCONFIG_PATH = "/etc/fonts";
      XDG_DATA_DIRS = "/app/share:/usr/share:/run/current-system/sw/share";
      ICON_THEME = "NEUX";
      GTK_FONT_NAME = "Fira Sans 11";
    };
  };

  # Flatpak's GLib hardcodes /usr/share/glib-2.0/schemas/ — NixOS doesn't have
  # that path, so we symlink the host schemas there on every activation.
  system.activationScripts.flatpak-glib-schemas = {
    supportsDryActivation = true;
    text = let
      schemaDir = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-50.1/glib-2.0/schemas";
    in ''
      mkdir -p /usr/share/glib-2.0/schemas
      ln -sf ${schemaDir}/*.xml /usr/share/glib-2.0/schemas/
      ln -sf ${schemaDir}/gschemas.compiled /usr/share/glib-2.0/schemas/
    '';
  };
}

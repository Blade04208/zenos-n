{ ... }:
{
  home-manager.sharedModules = [
    (
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {

        xdg.configFile."gtk-3.0/settings.ini".force = true;
        xdg.configFile."gtk-4.0/settings.ini".force = true;

        gtk = {
          enable = true;
          # iconTheme = {
          #   name = "Adwaita-hacks";
          # };
          # cursorTheme = {
          #   name = "GoogleDot-Black";
          #   size = 24;
          # };

          # [UPDATED] Use native package (Assuming it exists in 26.05)
          # font = {
          #   name = lib.mkForce "Fira Sans";
          #   package = lib.mkForce pkgs.fira-sans;
          # };

          # gtk3.extraConfig = {
          #   gtk-theme-name = "adw-gtk3-dark";
          #   gtk-application-prefer-dark-theme = 1;
          # };
          # gtk4.extraConfig = {
          #   gtk-application-prefer-dark-theme = 1;
          # };
        };

        # home.pointerCursor = {
        #   name = "GoogleDot-Black";
        #   size = 24;
        #   gtk.enable = true;
        #   x11.enable = true;
        # };

        dconf.settings = {

          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            accent-color = "purple";
            # gtk-theme = "adw-gtk3-dark";
            # icon-theme = "Adwaita-hacks";
            # cursor-theme = "GoogleDot-Black";
            # font-name = lib.mkForce "Fira Sans 11";
            # document-font-name = lib.mkForce "Fira Sans 11";
            # monospace-font-name = lib.mkForce "FiraMono Nerd Font 11";
          };
        };

        # home.file.".local/share/themes/adw-gtk3-dark".source =
        #   "${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark";
        # home.file.".local/share/icons/Adwaita-hacks".source = "${iconPkg}/share/icons/Adwaita-hacks";

        xdg.configFile."gtk-4.0/gtk.css".source = ./gtk.css;
        xdg.configFile."gtk-3.0/gtk.css".source = ./gtk.css;

      }
    )
  ];
}

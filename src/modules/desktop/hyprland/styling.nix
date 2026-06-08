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
          #   name = lib.mkForce "Fira Sans 11";
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

        xdg.configFile."gtk-3.0/gtk.css".text = ''
                   window.background {
          background: linear-gradient(180deg, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.125) 109.52%) , linear-gradient(rgba(81,81,81,0.3), rgba(81,81,81,0.3)), rgba(40,40,40,0.8);
           /*   border: 1px solid rgba(0, 0, 0, 0.4); */
              box-shadow: inset 0px 0px 0px 1px rgba(255, 255, 255, 0.077);
          border-radius: 10px;
          }

          headerbar, header, stack, .view {
          background: transparent;
          }
          headerbar {
          box-shadow: none;
          }

          notebook {
          background: rgba(0,0,0,0.4);
          border-radius: 10px 0px 0px 0px;
          border: 1px solid rgba(0, 0, 0, 0.2);
              box-shadow: inset 0px 4px 8px -2px rgba(0,0,0,0.2);
          }
          .sidebar {
          border: none;
          }

          menubutton button, .image-button:not(.close):not(.minimize):not(.maximize), .text-button, combobox {
          background: linear-gradient(180deg, rgba(0, 0, 0, 0.176364), rgba(0, 0, 0, 0.128) 20%, rgba(0, 0, 0, 0.239453) 40%, rgba(0, 0, 0, 0.4) 65%, rgba(0, 0, 0, 0.4) 75%, rgba(0, 0, 0, 0.28));
          border: 1px solid rgba(7,7,7,0.7);
          border-radius: 5px;
                }
        '';
        xdg.configFile."gtk-4.0/gtk.css".text = ''
                   window.background {
          background: linear-gradient(180deg, rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.125) 109.52%) , linear-gradient(rgba(81,81,81,0.3), rgba(81,81,81,0.3)), rgba(40,40,40,0.8);
           /*   border: 1px solid rgba(0, 0, 0, 0.4); */
              box-shadow: inset 0px 0px 0px 1px rgba(255, 255, 255, 0.077);
          border-radius: 10px;
          }

          headerbar, header, stack, .view {
          background: transparent;
          }
          headerbar {
          box-shadow: none;
          }

          notebook {
          background: rgba(0,0,0,0.4);
          border-radius: 10px 0px 0px 0px;
          border: 1px solid rgba(0, 0, 0, 0.2);
              box-shadow: inset 0px 4px 8px -2px rgba(0,0,0,0.2);
          }
          .sidebar {
          border: none;
          }

          menubutton button, .image-button:not(.close):not(.minimize):not(.maximize), .text-button, combobox {
          background: linear-gradient(180deg, rgba(0, 0, 0, 0.176364), rgba(0, 0, 0, 0.128) 20%, rgba(0, 0, 0, 0.239453) 40%, rgba(0, 0, 0, 0.4) 65%, rgba(0, 0, 0, 0.4) 75%, rgba(0, 0, 0, 0.28));
          border: 1px solid rgba(7,7,7,0.7);
          border-radius: 5px;
                }
        '';
      }
    )
  ];
}

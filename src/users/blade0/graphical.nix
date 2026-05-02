{
  inputs,
  ...
}:
{

  home-manager.users.blade0 =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        ./dconf.nix
        ./shortcuts.nix
        inputs.nixcord.homeModules.nixcord
      ];
      #home.file.".config/forge/config/windows.json".source = ./resources/windows.json;

      # Regular packages
      home.packages = with pkgs; [
        telegram-desktop
        # [P13.D] Ensure formatter is available for the LSP
        nixfmt-rfc-style
      ];

      # [USER SPECIFIC] VS Code Overrides
      # This extends the base configuration defined in dev.nix

      # [Masking] Create a "Discord" desktop entry that launches Vesktop
      # This ensures discord:// links work and it appears as "Discord" in the launcher.
      xdg.desktopEntries.discord = {
        name = "Discord";
        genericName = "Internet Messenger";
        exec = "vesktop %U";
        icon = "discord";
        type = "Application";
        categories = [
          "Network"
          "InstantMessaging"
        ];
        mimeType = [ "x-scheme-handler/discord" ];
        # [FIX] Link the running 'vesktop' window to this 'Discord' shortcut
        # This solves the issue of separate/generic icons appearing in the dock on Wayland.
        settings = {
          StartupWMClass = "vesktop";
          Keywords = "discord;vencord;vesktop;";
        };
      };

      programs.nixcord = {
        enable = true;

        # [SWITCHED] Using Vesktop instead of official Discord
        # Better Wayland support, screen sharing with audio, and performance.

        discord.enable = false;
        vesktop = {
          enable = true;
          autoscroll.enable = true;
          state = {
            "firstLaunch" = false;
            "windowBounds" = {
              "x" = 0;
              "y" = 0;
              "width" = 0;
              "height" = 0;
            };
          };
          settings = {
            # "hardwareVideoAcceleration" = true;
            "customTitleBar" = true;
            "staticTitle" = false;
          };
        };

        config = {
          useQuickCss = true;
          disableMinSize = true;

          # [FIX] Load themes into the menu as well, just in case QuickCSS fails.
          themeLinks = [
            "https://codeberg.org/ridge/Discord-Adblock/raw/branch/main/discord-adblock.css"
            "https://raw.githubusercontent.com/ricewind012/discord-gnome-theme/master/gnome.theme.css"
            # ↑ broken, hopefully replaced by gord soon
          ];

          # Global Vencord Settings
          enabledThemes = [
            "discord-adblock.css"
            "gnome.theme.css"
          ];

          # Highly Practical Plugin Configuration [p13.9 focus]
          plugins = {
            # Essentials
            fakeNitro = {
              enable = true;
              transformEmojis = true;
            };

            themeAttributes.enable = true;

            # UI Improvements
            betterFolders = {
              enable = false;
              sidebar = false;
              sidebarAnim = true;

            };
            memberCount.enable = true;
            showHiddenThings.enable = true;

            # [REMOVED] 'noMinSize' is not supported by current Nixcord version.
            # Enable this manually in Vencord settings -> Plugins if needed.

            # Privacy & Utility
            callTimer.enable = true;
            ClearURLs.enable = true;
            CopyUserURLs.enable = true;

            # Performance/Fixes
            # vencordToolbox.enable = true;
            webKeybinds.enable = true;

            # [NOTE] Often redundant on Vesktop (it has native fixes), but harmless to keep.
            webScreenShareFixes.enable = true;

            youtubeAdblock.enable = true;
          };
        };

        # [FIX] Added quotes to URLs to ensure CSS validity
        quickCss = ''
          .bar_c38106:nth-last-child(3) {
              margin-top: 0px;
          }
          :root {
              --chat-header-right-padding: calc(var(--titlebar-right-spacing) + var(--icon-button-size) * 2 + var(--spacing));
          }
        '';
      };
    };
}

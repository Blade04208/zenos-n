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
        vesktop
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
    };
}

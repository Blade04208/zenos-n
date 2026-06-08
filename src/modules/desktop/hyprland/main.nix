{ pkgs, inputs, ... }:
{
  imports = [
    ./styling.nix
  ];
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # backup apps - kitty
    kitty
    # shell
    ironbar
    swaynotificationcenter
    playerctl
    vicinae
    brightnessctl
    # hyprutils
    hyprpolkitagent
    hyprpaper
    hyprpicker
    hyprlock
    # screenshots
    grim
    slurp
    satty
    # bugfixes - giaselbhbr
    wl-clip-persist
    # styling - fira
    fira-sans
    nerd-fonts.fira-mono
  ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      gnome.default = [
        "gnome"
        "gtk"
      ];
    };
  };

  # home-manager = {
  #   # Import the ironbar home-manager module so programs.ironbar is available
  #   sharedModules = [ inputs.ironbar.homeManagerModules.default ];

  #   users.blade0 = {
  #     programs.ironbar = {
  #       enable = true;
  #       systemd = false;
  #       package = inputs.ironbar.packages.${pkgs.system}.ironbar;
  #       config = {
  #         monitors = {
  #           eDP-1 = {
  #             # run `hyprctl monitors` to confirm your monitor name
  #             anchor_to_edges = true;
  #             position = "top";
  #             height = 16;
  #             start = [
  #               { type = "clock"; }
  #             ];
  #             end = [
  #               {
  #                 type = "tray";
  #                 icon_size = 16;
  #               }
  #             ];
  #           };
  #         };
  #       };
  #       style = /* css */ ''
  #         * {
  #           font-family: Noto Sans Nerd Font, sans-serif;
  #           font-size: 16px;
  #           border: none;
  #           border-radius: 0;
  #         }
  #       '';
  #       # features only needed if ironbar was built with specific cargo features
  #       # remove if you're just using the default package
  #     };
  #   };
  # };
}

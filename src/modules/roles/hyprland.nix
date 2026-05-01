{ pkgs, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    # ironbar removed — home-manager manages it
  ];

  home-manager = {
    # Import the ironbar home-manager module so programs.ironbar is available
    sharedModules = [ inputs.ironbar.homeManagerModules.default ];

    users.blade0 = {
      programs.ironbar = {
        enable = true;
        systemd = true;
        package = inputs.ironbar.packages.${pkgs.system}.ironbar;
        config = {
          monitors = {
            eDP-1 = {
              # run `hyprctl monitors` to confirm your monitor name
              anchor_to_edges = true;
              position = "top";
              height = 16;
              start = [
                { type = "clock"; }
              ];
              end = [
                {
                  type = "tray";
                  icon_size = 16;
                }
              ];
            };
          };
        };
        style = /* css */ ''
          * {
            font-family: Noto Sans Nerd Font, sans-serif;
            font-size: 16px;
            border: none;
            border-radius: 0;
          }
        '';
        # features only needed if ironbar was built with specific cargo features
        # remove if you're just using the default package
      };
    };
  };
}

{ pkgs, inputs, ... }:
{

  programs.hyprland = {
    enable = true;
    withUWSM = false;
    xwayland.enable = true; # Xwayland can be disabled.
  };
  environment.systemPackages = with pkgs; [
    kitty
    ironbar
  ];
  # programs.ironbar = {
  #   enable = false;
  #   systemd = true;
  #   config = {
  #     # An example:
  #     monitors = {
  #       DP-1 = {
  #         anchor_to_edges = true;
  #         position = "top";
  #         height = 16;
  #         start = [
  #           { type = "clock"; }
  #         ];
  #         end = [
  #           {
  #             type = "tray";
  #             icon_size = 16;
  #           }
  #         ];
  #       };
  #     };
  #   };
  #   style = /* css */ ''
  #     /* An example */
  #     * {
  #       font-family: Noto Sans Nerd Font, sans-serif;
  #       font-size: 16px;
  #       border: none;
  #       border-radius: 0;
  #     }
  #   '';
  #   package = inputs.ironbar;
  #   features = [
  #     "feature"
  #     "another_feature"
  #   ];
  # };
}

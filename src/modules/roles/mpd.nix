{
  config,
  lib,
  pkgs,
  ...
}:

{
  # services.mopidy = {
  #   enable = true;
  #   extensionPackages = with pkgs; [
  #     mopidy-mpd
  #     mopidy-mpris
  #     mopidy-jellyfin
  #     mopidy-scrobbler
  #     mopidy-musicbox-webclient
  #   ];
  #   settings = {
  #     mpd = {
  #       enabled = true;
  #       hostname = "unix:/run/mpd/socket";
  #     };
  #     jellyfin = {
  #       hostname = "https://jellyfin.neg-zero.com";
  #       username = "blade0";
  #       password = lib.readFile "/var/lib/secrets/jellyfin-password";
  #     };
  #   };
  # };

  services.mpd = {
    enable = true;
    settings = {
      musicDir = "/music";
    };
  };
}

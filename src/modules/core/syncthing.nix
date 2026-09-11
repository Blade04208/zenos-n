# will contain generic syncthing settings and devices
{ lib, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "blade0";
    group = "users";
    dataDir = "/home/blade0";        # where its config/db goes
    configDir = "/home/blade0/.config/syncthing";
  };
}

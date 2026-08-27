# will contain generic syncthing settings and devices
{ lib, ... }:
{
  services.syncthing = {
    enable = true;

    # overrideDevices = true; # Overrides GUI settings with Nix config
    # overrideFolders = true; # Overrides GUI settings with Nix config

    openDefaultPorts = true;

    # settings.devices = lib.filterAttrs (n: v: v.id != "placeholder") {
    #   # blade
    #   "blade_phone" = {
    #     id = "2IUFQ74-QN2YOUC-FDX6W3H-F6E47QS-5TY3SOY-MMZD7FJ-JRLP2ZZ-RS56KAD";
    #   };
    # };
  };
}

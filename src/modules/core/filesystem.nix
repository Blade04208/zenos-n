{
  config,
  lib,
  pkgs,
  rootUUID ? "ROOT_UUID_PLACEHOLDER",
  bootUUID ? "BOOT_UUID_PLACEHOLDER",
  useLuks ? false,
  luksDeviceName ? "cryptroot",
  ...
}:

let
  cfg = config.services.zenos-filesystem;
in
{
  options.services.zenos-filesystem = {
    enable = lib.mkEnableOption "ZenOS core filesystem mounts";

    fsType = lib.mkOption {
      type = lib.types.str;
      default = "btrfs";
      description = "Filesystem type for the root partition.";
    };

    swapSize = lib.mkOption {
      type = lib.types.int;
      default = 8192;
      description = "Size of the swapfile in MB.";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems = {
      "/" = {
        device = if useLuks then "/dev/mapper/${luksDeviceName}" else "/dev/disk/by-uuid/${rootUUID}";
        fsType = cfg.fsType;
        neededForBoot = true;
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/${bootUUID}";
        fsType = "vfat";
        neededForBoot = true;
      };
    };

    swapDevices = [ {
      device = "/var/lib/swapfile";
      size = cfg.swapSize;
    } ];
  };
}

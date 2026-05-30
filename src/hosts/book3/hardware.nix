{
  config,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ============================================================================
  #  Galaxy Book3 (NP-750XFG-KA2UK) — hardware.nix
  #  Intel Core i5-1335U · Intel Iris Xe Graphics · 13th Gen Raptor Lake-U
  # ============================================================================

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt" # USB4 / Thunderbolt 4 port
    "nvme" # NVMe SSD
    "usb_storage"
    "sd_mod"
    "sdhci_pci" # microSD card reader (Galaxy Book3 uses SDHCI, not rtsx)
  ];

  boot.initrd.kernelModules = [
    "nls_cp437"
    "nls_iso8859_1"
    "vfat"
  ];

  boot.kernelModules = [
    "kvm-intel"
    "i915" # Intel Iris Xe uses i915 (not xe — that driver is unstable on this gen)
    "nls_cp437"
    "nls_iso8859_1"
    "vfat"
    "samsung_galaxybook" # Samsung platform driver: fan, kbd backlight, ACPI (kernel ≥ 6.9)
    # "acpi_call"        # Uncomment if you need low-level ACPI calls for Samsung quirks
  ];

  boot.extraModulePackages = [ ];

  # [ Networking ]
  networking.useDHCP = lib.mkDefault true;

  # [ CPU Microcode ]
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.etc."udev/rules.d/90-disable-touchpad.rules".text = ''
    SUBSYSTEM=="input", ATTR{name}=="ELAN0B00:00 04F3:3261 Touchpad", RUN+="/bin/sh -c 'echo -n $kernel > /sys/bus/usb/drivers/usb/unbind'"
  '';

}

{
  pkgs,
  lib,
  useLuks ? false,
  luksDeviceName ? "cryptroot",
  rootUUID ? "ROOT_UUID_PLACEHOLDER",
  isVM ? false,
  ...
}:

let
  # Path to your custom python script relative to this file
  refindScript = ../../scripts/refind.py;
  # Path to resources (Theme, icons, etc.)
  refindResources = ../../../resources/Refind;
in
{
  boot = {
    # [ SILENCE ] Essential settings for a flicker-free boot
    # Note: Plymouth is enabled in your branding module.
    # These settings hide the text *before* Plymouth starts.
    consoleLogLevel = 0;
    initrd.verbose = false;

    initrd.availableKernelModules = lib.mkIf useLuks [
      "cryptsetup"
    ];

    initrd.kernelModules = lib.mkIf useLuks [
      "dm_mod"
    ];

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    initrd.luks.devices = lib.mkIf useLuks {
      ${luksDeviceName}.device = "/dev/disk/by-uuid/${rootUUID}";
    };

    loader = {
      # [ TIMEOUT ] Set to 0 to hide systemd-boot and boot immediately
      # This effectively delegates the menu strictly to rEFInd
      timeout = 0;

      # 1. Standard systemd-boot for generation management
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };

      # 2. Prevent NixOS from fighting rEFInd for the #1 Boot Order slot
      efi = lib.mkIf (!isVM) {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
    };
  };

  # Activation Scripts (skipped for VMs — no rEFInd needed)
  system.activationScripts = lib.mkIf (!isVM) {

    # A. Unattended rEFInd Installation
    installRefind = {
      supportsDryActivation = true;
      text = ''
        export PATH="${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.gptfdisk
            pkgs.gnused
            pkgs.gnugrep
          ]
        }:$PATH"

        # [ FIX ] Use /boot instead of /Boot to avoid race conditions with NZFS symlinks
        if [ ! -f /boot/EFI/refind/refind_x64.efi ]; then
            echo "rEFInd not found. Performing unattended installation..."
            ${pkgs.refind}/bin/refind-install --yes
        fi
      '';
    };

    # B. Copy Resources (Themes/Icons)
    # Copies local resources/Refind/* to the ESP, overwriting conflicts.
    copyRefindResources = {
      supportsDryActivation = true;
      deps = [ "installRefind" ];
      text = ''
        echo "Deploying rEFInd resources..."

        # Check if the store path exists (it always should if Nix builds successfully)
        if [ -d "${refindResources}" ]; then
            # -L: Dereference symlinks (copy actual file content)
            # -f: Force overwrite of existing files
            # -r: Recursive
            # --no-preserve=mode: Ensures files on target are writable (fixes Read-Only Store issues)
            cp -Lrf --no-preserve=mode ${refindResources}/. /boot/EFI/refind/
        else
            echo "## [ ! ] WARNING: Resource path ${refindResources} implies empty or missing source."
        fi
      '';
    };

    # C. The Python "Mesh" Sync
    syncRefindGenerations = {
      supportsDryActivation = true;
      # Runs after resources are copied to ensure config references exist
      deps = [ "copyRefindResources" ];
      text = ''
        echo "Syncing NixOS generations with rEFInd via Python script..."
        ${pkgs.python3}/bin/python3 ${refindScript}
      '';
    };
  };

  environment.systemPackages = lib.mkIf (!isVM) (with pkgs; [
    refind
    efibootmgr
    python3
    gptfdisk
    gnused
  ]);
}

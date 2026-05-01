{
  pkgs,
  lib,
  ...
}:

{
  # ============================================================================
  #  Galaxy Book3 (NP-750XFG-KA2UK)
  #  Intel Core i5-1335U (2P + 8E, 15W TDP) · Intel Iris Xe Graphics
  #  8GB LPDDR4x · 256GB NVMe · Wi-Fi 6 (AX201) · 15.6" FHD
  # ============================================================================

  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  # scx_lavd is well-suited for asymmetric P+E core topologies like the i5-1335U
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  # [ Hardware ]
  hardware = {
    # Galaxy Book3 (non-360) is not a 2-in-1, but still exposes an ambient
    # light sensor via IIO — keep enabled for auto-brightness if your DE supports it.
    sensor.iio.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Intel Iris Xe Graphics — i915 driver, iHD media stack
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # iHD: required for 6th gen+, covers all Xe hardware
        libvdpau-va-gl
        # intel-vaapi-driver (i965) is NOT needed for 13th gen — iHD handles everything
      ];
    };
  };

  # [ Environment Variables ]
  environment.variables = {
    LIBVA_DRIVER_NAME = "iHD";       # Force iHD for VA-API (correct for Iris Xe)
    MOZ_DISABLE_RDD_SANDBOX = "1";  # Required for Firefox hardware video decode via VAAPI
  };

  # [ Nix Binary Caches ]
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://cachyos.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen; # Zen kernel includes samsung_galaxybook since 6.9

    supportedFilesystems = {
      btrfs = true;
      ext4 = true;
      vfat = true;
    };

    kernelModules = [ "msr" ];

    kernelParams = [
      "mitigations=off"
      "quiet"
      "splash"

      # Intel Iris Xe — GuC/HuC submission is required for proper Xe scheduling
      "i915.enable_guc=3"
      "i915.enable_fbc=1"   # Framebuffer compression — saves memory bandwidth on LPDDR4x

      # Samsung ACPI quirks
      # acpi_osi=Linux: exposes Linux-compatible ACPI tables; fixes backlight/hotkey routing
      "acpi_osi=Linux"
      # acpi_backlight=native: prevents multiple backlight drivers fighting over /sys/class/backlight
      "acpi_backlight=native"

      # Modern Standby (S0ix) — Galaxy Book3 uses s2idle, NOT S3 deep sleep
      "mem_sleep_default=s2idle"

      "nowatchdog"
    ];

    # Redundant with kernelParams above, but acts as a module-level override
    # in case dracut or initrd loads i915 before cmdline params apply.
    extraModprobeConfig = ''
      options i915 enable_fbc=1 enable_guc=3
    '';

    # [ Memory Pressure Tuning ]
    # Tuned for 8GB LPDDR4x + ZRAM. Prioritises keeping active pages in RAM
    # by pushing cold pages into compressed swap early.
    kernel.sysctl = {
      # ZRAM-first swap policy
      "vm.swappiness"              = lib.mkForce 130;  # Aggressively prefer ZRAM over eviction
      "vm.watermark_boost_factor"  = lib.mkForce 0;    # No burst reclaim (reduces latency spikes)
      "vm.watermark_scale_factor"  = lib.mkForce 125;  # Wider headroom before direct reclaim
      "vm.page-cluster"            = 0;                # Read single pages (optimal for ZRAM latency)

      # NVMe queue depth hint (some kernels ignore this; harmless either way)
      "dev.nvme.0.queue_mode" = "none";
    };
  };

  # [ ZRAM ]
  # 8GB RAM * 100% = up to 8GB compressed swap. With zstd this gives effectively
  # ~16–24GB usable before hitting OOM — essential given the base 8GB config.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  # [ Power Management ]
  services = {
    # thermald handles Intel adaptive thermal control via DPTF — keep enabled.
    thermald.enable = true;

    # power-profiles-daemon exposes power profiles (balanced/performance/power-saver)
    # to GNOME/KDE and userspace tools.
    # NOTE: power-profiles-daemon CONFLICTS with throttled.
    # If you enable throttled below, set this to false.
    power-profiles-daemon.enable = true;

    # throttled (lenovo-throttling-fix) can set RAPL power limits via MSR even on
    # non-ThinkPad hardware, but its Samsung EC integration is nonexistent.
    # Use it only for RAPL TDP capping — ignore the [UNDERVOLT] section entirely,
    # as 13th gen Raptor Lake locks voltage MSRs in firmware.
    #
    # i5-1335U rated TDP: 15W (configurable 9–55W PL2 burst)
    # NOTE: Disable power-profiles-daemon above if you enable this.
    throttled = {
      enable = false; # Toggle on/off alongside power-profiles-daemon
      extraConfig = ''
        [GENERAL]
        Enabled: True
        # Galaxy Book3 uses BAT1, not BAT0 (unlike ThinkPads)
        Sysfs_Power_Path: /sys/class/power_supply/BAT1/status
        Autoload: True

        [BATTERY]
        Update_Rate_s: 30
        PL1_Tdp_W: 15      # Rated TDP for i5-1335U — conservative on battery
        PL1_Duration_s: 28
        PL2_Tdp_W: 30      # Short boost headroom — keeps thermals sane on 15W chassis
        PL2_Duration_s: 0.002
        Trip_Temp_C: 78

        [AC]
        Update_Rate_s: 5
        PL1_Tdp_W: 28      # Sustained AC power limit — balanced performance
        PL1_Duration_s: 28
        PL2_Tdp_W: 55      # Max PL2 burst (spec limit for i5-1335U)
        PL2_Duration_s: 0.002
        Trip_Temp_C: 88

        # [UNDERVOLT] — REMOVED
        # 13th Gen Intel (Raptor Lake) locks voltage control registers in firmware.
        # Any MSR undervolt attempts will fail silently or cause instability.
        # Do not add UNDERVOLT entries here.
      '';
    };

    # OOM killer — important given the 8GB baseline
    earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 5;
    };

    # services.undervolt — REMOVED
    # The undervolt NixOS service targets Intel pre-12th gen MSR voltage offsets.
    # These MSRs are write-protected on Raptor Lake. The service will fail or,
    # in rare cases, cause boot issues. Use thermald + RAPL limits instead.
  };

  # [ Sleep Configuration ]
  systemd = {
    sleep.extraConfig = ''
      [Sleep]
      # Galaxy Book3 does not properly support ACPI S3 (deep sleep).
      # s2idle (Modern Standby / S0ix) is the correct suspend target.
      SuspendMode=s2idle
      SuspendState=freeze
      HibernateMode=platform
      HibernateState=disk
    '';

    # BD_PROCHOT dethrottle — ThinkPad-specific thermal safety mechanism.
    # Samsung Galaxy Book3 does not use BD_PROCHOT via this MSR in the same way.
    # This service is left here disabled. If you observe unexpected sustained
    # throttling under load, you may experiment with re-enabling it.
    services.disable-throttling = {
      enable = false;
      description = "Disable BD_PROCHOT Throttling (experimental on Samsung)";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c 'if [ -e /dev/cpu/0/msr ]; then ${pkgs.msr-tools}/bin/wrmsr 0x1FC 2 || true; fi'";
        After = [ "local-fs.target" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    libimobiledevice       # iOS device mounting (optional, remove if unused)
    libimobiledevice-glue
    # libsmbios removed — Dell/Lenovo SMBIOS utility, irrelevant on Samsung hardware
    msr-tools              # Useful for reading/debugging MSR state (e.g. RAPL power readings)
    intel-gpu-tools        # intel_gpu_top, GPU debugging
    # undervolt removed — not compatible with 13th gen Intel (Raptor Lake)
  ];
}

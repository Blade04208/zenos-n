# Generic VM — virtio drivers, display, minimal tuning
{ pkgs, lib, ... }:

{
  # Virtio GPU — uses SimpleDRM in early boot, virtio-gpu in userspace
  hardware.graphics.enable = true;

  # Virtio guest agent for host ↔ VM integration
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Shared clipboard and display resizing
  services.xserver = {
    videoDrivers = [ "modesetting" "virtio" ];
  };

  # Virtiofs for host-shared folders
  boot.initrd.kernelModules = [ "virtiofs" ];

  environment.systemPackages = with pkgs; [
    spice-guest-tools
    spice-vdagent
    qemu-guest-agent
  ];

  # Disable unnecessary power management in VM
  powerManagement.enable = false;
  services.thermald.enable = false;
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = false;
}

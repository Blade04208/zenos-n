{
  config,
  inputs,
  pkgs,
  ...
}:
{
  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="0e8d", MODE="0666", GROUP="plugdev"
'';
}
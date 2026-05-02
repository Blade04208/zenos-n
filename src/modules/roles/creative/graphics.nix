# creativity tools
{ pkgs, ... }:
{
  services.flatpak.packages = [

    # --- Graphics & Design ---
    "org.gnome.design.AppIconPreview"
    "org.gnome.design.IconLibrary"
    "re.sonny.OhMySVG" # SVG optimizer
  ];
}

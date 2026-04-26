# creativity tools
{ pkgs, ... }:
{
  services.flatpak.packages = [

    # --- Graphics & Design ---
    "org.gnome.design.AppIconPreview"
    "org.gnome.design.IconLibrary"
    "org.gnome.design.Palette"
    "re.sonny.OhMySVG" # SVG optimizer

  ];
}

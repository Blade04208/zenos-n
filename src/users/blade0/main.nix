# kitchen sink for the user
{
  config,
  inputs,
  pkgs,
  ...
}:

{
  users.users.blade0 = {
    isNormalUser = true;
    description = "blade0";
    extraGroups = [
      "wheel"
      "networkmanager"
      "zenos-rebuild"
      "plugdev"
    ];
    shell = pkgs.fish;
    initialPassword = "setmelater";
  };
  nixpkgs.overlays = [ inputs.helium-flake.overlays.default ];
  environment.systemPackages = with pkgs; [
    bazaar
    btop
    ungoogled-chromium
    fira-code
    micro
    helium
    inputs.swisstag.packages.${pkgs.system}.default
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];
  home-manager.users.blade0 = {
    # never touch this
    home.stateVersion = "26.05";

    home.file = {
      # ".local/bin".source = ./bin;
    };
    xdg.userDirs = {
      enable = false;
      download = config.users.users.blade0.home + "/Downloads";
      createDirectories = false;
    };

    imports = [ inputs.neux.homeManagerModules.default ];
    neux = {
      wm = "hyprland";
      favorites = [
        "app.zen_browser.zen"
        "org.gnome.Nautilus"
        "org.gajim.Gajim"
        "io.m51.Gelly"
        "org.gnome.Ptyxis"
        "dev.zed.Zed"
      ];
    };

    programs = {

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      fish = {

        enable = true;
        # [P13.9] User-Specific Tools
        # Removed CD shortcuts as Zoxide handles navigation
        shellAliases = {
          # Git Rapid-Fire
          g = "git";
          ga = "git add";
          gaa = "git add .";
          gc = "git commit -m";
          gs = "git status";
          gp = "git push";
          gl = "git log --oneline --graph --decorate";

          # Nix / Direnv
          da = "direnv allow";
          dr = "direnv reload";

          # Networking
          myip = "fastfetch -l none -s localip:publicip";
          up = "fastfetch -l none -s uptime";
        };
      };

      zoxide = {

        enable = true;
        enableFishIntegration = true;
      };

      git = {
        enable = true;
        settings = {
          user = {
            name = "blade0";
            email = "blade0@blade0.net";
          };
          pull.rebase = false;
          init.defaultBranch = "main";
        };
      };
    };
  };
  services.flatpak.packages = [
    "io.m51.Gelly"
    "com.github.IsmaelMartinez.teams_for_linux"
    "com.obsproject.Studio"
    "io.mrarm.mcpelauncher"
    "app.zen_browser.zen"
    "org.kde.iconexplorer"
  ];
}

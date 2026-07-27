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
  environment.systemPackages = with pkgs; [
    bazaar
    btop
    ungoogled-chromium
    fira-code
    ghostty
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

    neux = {
      favorites = [
        "app.zen_browser.zen"
        "org.gnome.Nautilus"
        "org.gnome.Ptyxis"
        "dev.zed.zed"
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
          myip = "curl ifconfig.me";
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

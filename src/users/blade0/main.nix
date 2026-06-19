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
    shell = pkgs.zsh;
    initialPassword = "setmelater";
  };
  environment.systemPackages = with pkgs; [
    bazaar
    btop
  ];
  home-manager.users.blade0 = {

    # never touch this
    home.stateVersion = "26.05";

    home.file = {
      ".p10k.zsh".source = ./resources/p10k.zsh;
      # ".local/bin".source = ./bin;
    };
    xdg.userDirs = {
      enable = true;
      download = config.users.users.blade0.home + "/Downloads";
      createDirectories = false;
    };

    programs = {

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      zsh = {

        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

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

        history.size = 10000;

        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            {
              name = "romkatv/powerlevel10k";
              tags = [
                "as:theme"
                "depth:1"
              ];
            }
          ];
        };

        initContent = ''
          bindkey "''${key[Up]}" up-line-or-search
          bindkey "''${key[Down]}" down-line-or-search
        '';
      };

      zoxide = {

        enable = true;
        enableZshIntegration = true;
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
    "com.jeffser.Nocturne" # Nocturne
    "re.sonny.Workbench"
    "com.github.IsmaelMartinez.teams_for_linux"
    "com.obsproject.Studio"
    "io.mrarm.mcpelauncher"
    "app.zen_browser.zen"
    "de.haeckerfelix.Shortwave"
  ];  
}

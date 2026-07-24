{
  pkgs,
  ...
}:
let
  # [ ACTION ] Import zenos-rebuild directly from source
  zenosRebuild = pkgs.writeScriptBin "zenos-rebuild" (
    builtins.readFile ../../scripts/zenos-rebuild.sh
  );

  # [ ACTION ] Import P10k Config
  # We read the file content directly into a store file
  p10kConfig = pkgs.writeText "headline.zsh-theme" (builtins.readFile ../../../resources/shell/headline/headline.zsh-theme);

in
{
  security.sudo.extraRules = [
    {
      groups = [ "zenos-rebuild" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  users.groups.zenos-rebuild = { };

  # [ ACTION ] Map the config to a global location
  environment.etc."zsh/headline.zsh-theme".source = p10kConfig;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    histSize = 10000;

    # [P13.9] Practical Aliases using eza
    shellAliases = {
      # The 'eza' suite
      ls = "eza --icons=always --group-directories-first";
      ll = "eza -lah --icons=always --group-directories-first --git";
      lt = "eza --tree --level=2 --icons=always";

      # NixOS Management
      nos = "zenos-rebuild";
      noc = "sudo nix-collect-garbage -d";
    };

    shellInit = ''
      # Navigation: Search-based keys + word-jumping (Ctrl + Arrows)
      bindkey "^[[A" up-line-or-search
      bindkey "^[[B" down-line-or-search
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      
      # [FIX] Source the system-wide config instead of the user one
      # We check if the global config exists and source it
      [[ ! -f /etc/zsh/headline.zsh-theme ]] || source /etc/zsh/headline.zsh-theme
    '';

  };

  # SSH Service
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };

  environment.systemPackages = with pkgs; [
    eza
    fzf
    tree
    zsh-powerlevel10k

    tmux
    zenosRebuild
    libnotify
  ];

  security.unprivilegedUsernsClone = true;
}

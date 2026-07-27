{
  pkgs,
  ...
}:
let
  # [ ACTION ] Import zenos-rebuild directly from source
  zenosRebuild = pkgs.writeScriptBin "zenos-rebuild" (
    builtins.readFile ../../scripts/zenos-rebuild.sh
  );
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
  programs.fish = {
    enable = true;

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
    tmux
    zenosRebuild
    libnotify
  ];

  security.unprivilegedUsernsClone = true;
}

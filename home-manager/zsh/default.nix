{ pkgs, ... }:
{
  programs = {
    starship.enable = true;
    direnv.enable = true;
    fzf.enable = true;

    command-not-found = {
      enable = true;
      dbPath = "${pkgs.path}/programs.sqlite";
    };

    zsh = {
      enable = true;
      shellAliases = {
        conf = "(cd ~/nix-configs/ && vim $(fzf))";
        rebuild = "sudo nixos-rebuild switch";
      };
      defaultKeymap = "viins";
      initContent = builtins.readFile ./zshrc;
    };
  };
}

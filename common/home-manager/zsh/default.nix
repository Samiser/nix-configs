{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let cfg = config.sam.zsh;
in {
  options.sam.zsh.enable = mkEnableOption "zsh config";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        conf = "(cd ~/nix-configs/ && vim $(fzf))";
        rebuild = "sudo nixos-rebuild switch";
      };
      defaultKeymap = "viins";
      initExtra = builtins.readFile ./zshrc;
    };
  };
}

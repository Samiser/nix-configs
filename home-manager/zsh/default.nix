{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.sam.zsh;
in
{
  options.sam.zsh.enable = mkEnableOption "zsh config";

  config = mkIf cfg.enable {
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
  };
}

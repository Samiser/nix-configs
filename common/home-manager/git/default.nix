{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let cfg = config.sam.git;
in {
  options.sam.git.enable = mkEnableOption "git config";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Samiser";
      userEmail = "github@me.samiser.xyz";
    };
  };
}

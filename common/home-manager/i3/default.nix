{ lib, config, nixosConfig, pkgs, ... }:

with lib;

let cfg = config.sam.i3;
in {
  options.sam.i3.enable = mkEnableOption "i3 config";

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      config = { bars = [ ]; };
      extraConfig = builtins.readFile ./config;
    };
  };
}

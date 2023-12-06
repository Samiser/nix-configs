{ config, pkgs, lib, ... }:

with lib;
let cfg = config.hostConfig.i3;
in {
  options.hostConfig.i3.enable = mkEnableOption "i3";

  config = mkIf cfg.enable {
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [ rofi dunst picom i3blocks i3lock-fancy ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hostConfig.i3;
in {
  options.hostConfig.i3.enable = lib.mkEnableOption "i3 window manager";

  config = lib.mkIf cfg.enable {
    services.displayManager.defaultSession = "xfce+i3";
    services.xserver = {
      enable = true;
      autorun = true;
      xkb.layout = "gb";
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3;
        extraPackages = with pkgs; [rofi dunst picom i3blocks i3lock-fancy];
      };
    };
  };
}

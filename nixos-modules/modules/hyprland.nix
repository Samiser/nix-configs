{
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.hyprland;
in
{
  options.hostConfig.hyprland.enable = lib.mkEnableOption "Hyprland Wayland compositor";

  config = lib.mkIf cfg.enable {
    programs.hyprland.enable = true;
  };
}

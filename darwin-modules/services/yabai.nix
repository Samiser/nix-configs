{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sam.services.yabai;
in {
  options.sam.services.yabai.enable = lib.mkEnableOption "yabai config";
  config = lib.mkIf cfg.enable {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      package = pkgs.yabai;
      config = {
        # yabai should manage windows
        layout = "bsp";

        # new window spawns to the right if vertical split, or bottom if horizontal split
        window_placement = "second_child";

        # set all padding and gaps to 15pt
        top_padding = 8;
        bottom_padding = 15;
        left_padding = 15;
        right_padding = 15;
        window_gap = 15;

        # set focus follows mouse mode
        focus_follows_mouse = "autoraise";

        # show shadows only for floating windows
        window_shadow = "float";
        menubar_opacity = "0.0";
      };
      extraConfig = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        yabai -m rule --add app="^System Settings$" manage=off
        yabai -m rule --add app="^Raycast$" manage=off
      '';
    };
  };
}

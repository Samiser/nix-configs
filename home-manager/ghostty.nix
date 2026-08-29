{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.sam.ghostty;
in
{
  options.sam.ghostty.enable = lib.mkEnableOption "ghostty config";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.ghostty = {
          enable = true;
          package = null;
          settings = {
            window-padding-x = 5;
            window-padding-y = 5;
            font-size = 10;
            background-opacity = 0.8;
            background-blur = true;
            custom-shader = "${./cursor_smear.glsl}";
          }
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            macos-titlebar-style = "hidden";
            keybind = [ "global:opt+enter=new_window" ];
          };
        };
      }
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        programs.ghostty = {
          systemd.enable = false;
          settings.theme = "noctalia";
        };
      })
    ]
  );
}

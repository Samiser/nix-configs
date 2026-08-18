{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.sam.ghostty;
in
{
  options.sam.ghostty.enable = mkEnableOption "ghostty config";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.ghostty.enable = true;
      programs.ghostty.package = null;
      programs.ghostty.settings = {
        window-padding-x = 5;
        window-padding-y = 5;
        font-size = 10;
        background-opacity = 0.8;
        background-blur = true;
        custom-shader = "${./cursor_smear.glsl}";
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
        macos-titlebar-style = "hidden";
      };
    }
    (mkIf pkgs.stdenv.hostPlatform.isLinux {
      programs.ghostty.systemd.enable = false;
      programs.ghostty.settings.theme = "noctalia";
    })
  ]);
}

{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.sam.alacritty;
in {
  options.sam.alacritty.enable = mkEnableOption "alacritty config";

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 7;
        window = {
          padding.x = 10;
          padding.y = 10;
          opacity = 0.9;
        };
        env.TERM = "xterm-256color";
      };
    };
  };
}

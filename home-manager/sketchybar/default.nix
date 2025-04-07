{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.sam.sketchybar;
in {
  options.sam.sketchybar.enable = mkEnableOption "sketchybar config";

  config = mkIf cfg.enable {
    home.activation.sketchybar = lib.hm.dag.entryAfter ["writeBoundary"] "/opt/homebrew/bin/sketchybar --reload";

    home.file.".config/sketchybar".source = ./config;
  };
}

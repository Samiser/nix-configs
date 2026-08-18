{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.sam.omniwm;
in
{
  options.sam.omniwm.enable = mkEnableOption "omniwm config";

  config = mkIf cfg.enable {
    xdg.configFile."omniwm/settings.toml" = {
      source = ./settings.toml;
      force = true;
    };
  };
}

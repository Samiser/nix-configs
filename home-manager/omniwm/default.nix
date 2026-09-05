{
  lib,
  config,
  ...
}:
let
  cfg = config.sam.omniwm;
in
{
  options.sam.omniwm.enable = lib.mkEnableOption "omniwm config";

  config = lib.mkIf cfg.enable {
    xdg.configFile."omniwm/settings.toml" = {
      source = ./settings.toml;
      force = true;
    };
  };
}

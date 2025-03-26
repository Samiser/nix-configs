{
  config,
  lib,
  ...
}: let
  cfg = config.sam.services.jankyborders;
in {
  options.sam.services.jankyborders.enable = lib.mkEnableOption "jankyborders config";
  config = lib.mkIf cfg.enable {
    services.jankyborders = {
      enable = true;
      active_color = "0xffe1e3e4";
      inactive_color = "gradient(top_right=0x9992B3F5,bottom_left=0x9992B3F5)";
    };
  };
}

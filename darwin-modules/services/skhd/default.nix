{
  config,
  lib,
  ...
}: let
  cfg = config.sam.services.skhd;
in {
  options.sam.services.skhd.enable = lib.mkEnableOption "skhd config";
  config = lib.mkIf cfg.enable {
    services.skhd = {
      enable = true;
      skhdConfig = builtins.readFile ./skhdrc;
    };
  };
}

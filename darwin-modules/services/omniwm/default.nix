{
  config,
  lib,
  ...
}:
let
  cfg = config.sam.services.omniwm;
in
{
  imports = [ ./module.nix ];

  options.sam.services.omniwm.enable = lib.mkEnableOption "omniwm config";

  config = lib.mkIf cfg.enable {
    services.omniwm.enable = true;
  };
}

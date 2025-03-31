{
  config,
  lib,
  ...
}: let
  cfg = config.sam.services.tailscale;
in {
  options.sam.services.tailscale.enable = lib.mkEnableOption "tailscale config";
  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}

{
  config,
  lib,
  ...
}: let
  cfg = config.services.tailscale-local;
in {
  options.services.tailscale-local = {
    enable = lib.mkEnableOption "Tailscale VPN";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    # exit nodes don't work without this (see https://github.com/tailscale/tailscale/issues/4432)
    networking.firewall.checkReversePath = "loose";
  };
}

{
  services.tailscale.enable = true;
  # exit nodes don't work without this (see https://github.com/tailscale/tailscale/issues/4432)
  networking.firewall.checkReversePath = "loose";
}

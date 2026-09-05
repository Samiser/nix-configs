_: {
  services.seerr = {
    enable = true;
    openFirewall = false;
  };

  # Only allow on Tailscale interface
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5055 ];
}

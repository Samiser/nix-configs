{pkgs, ...}: {
  services.jellyseerr = {
    enable = true;
    openFirewall = false;
  };

  # Wait for Tailscale before starting
  systemd.services.jellyseerr = {
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "jellyseerr-wait-tailscale" ''
      until ${pkgs.tailscale}/bin/tailscale status &>/dev/null; do sleep 1; done
    '';
  };

  # Only allow on Tailscale interface
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [5055];
}

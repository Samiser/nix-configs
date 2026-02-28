{pkgs, ...}: {
  services.prowlarr = {
    enable = true;
    openFirewall = false;
  };

  # Bind Prowlarr to Tailscale interface only
  systemd.services.prowlarr = {
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    path = [pkgs.tailscale pkgs.gnused];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "prowlarr-setup" ''
      # Wait for Tailscale to be ready
      until tailscale status &>/dev/null; do sleep 1; done
      TSIP=$(tailscale ip -4)
      CONF_FILE="/var/lib/prowlarr/config.xml"
      if [ -f "$CONF_FILE" ]; then
        sed -i "s|<BindAddress>.*</BindAddress>|<BindAddress>$TSIP</BindAddress>|" "$CONF_FILE"
      fi
    '';
  };
}

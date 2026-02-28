{pkgs, ...}: {
  services.radarr = {
    enable = true;
    openFirewall = false;
  };

  # Bind Radarr to Tailscale interface only
  systemd.services.radarr = {
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    path = [pkgs.tailscale pkgs.gnused];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "radarr-setup" ''
      # Wait for Tailscale to be ready
      until tailscale status &>/dev/null; do sleep 1; done
      TSIP=$(tailscale ip -4)
      CONF_FILE="/var/lib/radarr/.config/Radarr/config.xml"
      if [ -f "$CONF_FILE" ]; then
        sed -i "s|<BindAddress>.*</BindAddress>|<BindAddress>$TSIP</BindAddress>|" "$CONF_FILE"
      fi
    '';
  };
}

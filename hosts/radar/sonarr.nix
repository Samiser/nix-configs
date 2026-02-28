{pkgs, ...}: {
  services.sonarr = {
    enable = true;
    openFirewall = false;
  };

  users.users.sonarr.extraGroups = ["radarr"];

  # Bind Sonarr to Tailscale interface only
  systemd.services.sonarr = {
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    path = [pkgs.tailscale pkgs.gnused];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "sonarr-setup" ''
      # Wait for Tailscale to be ready
      until tailscale status &>/dev/null; do sleep 1; done
      TSIP=$(tailscale ip -4)
      CONF_FILE="/var/lib/sonarr/.config/NzbDrone/config.xml"
      if [ -f "$CONF_FILE" ]; then
        sed -i "s|<BindAddress>.*</BindAddress>|<BindAddress>$TSIP</BindAddress>|" "$CONF_FILE"
      fi
    '';
  };
}

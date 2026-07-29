{pkgs, ...}: let
  bindToTailscale = service: configFile: {
    after = ["tailscaled.service"];
    requires = ["tailscaled.service"];
    path = [pkgs.tailscale pkgs.gnused];
    serviceConfig.ExecStartPre = pkgs.writeShellScript "${service}-setup" ''
      # Wait for Tailscale to be ready
      until tailscale status &>/dev/null; do sleep 1; done
      TSIP=$(tailscale ip -4)
      CONF_FILE="${configFile}"
      if [ -f "$CONF_FILE" ]; then
        sed -i "s|<BindAddress>.*</BindAddress>|<BindAddress>$TSIP</BindAddress>|" "$CONF_FILE"
      fi
    '';
  };
in {
  services = {
    radarr = {
      enable = true;
      openFirewall = false;
    };
    sonarr = {
      enable = true;
      openFirewall = false;
    };
    prowlarr = {
      enable = true;
      openFirewall = false;
    };
  };

  users.users.sonarr.extraGroups = ["radarr"];

  systemd.services = {
    radarr = bindToTailscale "radarr" "/var/lib/radarr/.config/Radarr/config.xml";
    sonarr = bindToTailscale "sonarr" "/var/lib/sonarr/.config/NzbDrone/config.xml";
    prowlarr = bindToTailscale "prowlarr" "/var/lib/prowlarr/config.xml";
  };
}

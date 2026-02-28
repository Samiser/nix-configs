{config, pkgs, ...}: let
  vpnInterface = "wg-mullvad";
in {
  age.secrets.mullvad-privkey = {
    file = ../../secrets/mullvad-privkey.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  # WireGuard tunnel to Mullvad
  networking.wg-quick.interfaces.${vpnInterface} = {
    address = ["10.71.159.207/32"];
    privateKeyFile = config.age.secrets.mullvad-privkey.path;

    peers = [{
      publicKey = "veLqpZazR9j/Ol2G8TfrO32yEhc1i543MCN8rpy1FBA=";
      allowedIPs = ["0.0.0.0/0" "::/0"];
      endpoint = "185.204.1.203:51820";
      persistentKeepalive = 25;
    }];

    # Don't route all traffic through VPN, only traffic from qbittorrent
    # We'll use a separate routing table for this
    table = "51820";
    postUp = ''
      # Route Tailscale traffic through Tailscale's table (before the VPN rule)
      ${pkgs.iproute2}/bin/ip rule add uidrange 888-888 to 100.64.0.0/10 lookup 52 priority 5208
      # Route everything else through VPN
      ${pkgs.iproute2}/bin/ip rule add uidrange 888-888 table 51820 priority 5209
    '';
    postDown = ''
      ${pkgs.iproute2}/bin/ip rule del uidrange 888-888 to 100.64.0.0/10 lookup 52 priority 5208 || true
      ${pkgs.iproute2}/bin/ip rule del uidrange 888-888 table 51820 priority 5209 || true
    '';
  };

  # qbittorrent user with specific UID for routing rules
  users.users.qbittorrent = {
    isSystemUser = true;
    uid = 888;
    group = "qbittorrent";
    extraGroups = ["radarr"];  # For storagebox access
    home = "/var/lib/qbittorrent";
    createHome = true;
  };
  users.groups.qbittorrent.gid = 888;

  # qbittorrent-nox service
  systemd.services.qbittorrent = {
    description = "qBittorrent-nox";
    after = ["network.target" "wg-quick-${vpnInterface}.service" "tailscaled.service"];
    wants = ["wg-quick-${vpnInterface}.service"];
    requires = ["tailscaled.service"];
    wantedBy = ["multi-user.target"];

    path = [pkgs.tailscale pkgs.gnused];

    serviceConfig = {
      Type = "simple";
      User = "qbittorrent";
      Group = "qbittorrent";
      ExecStartPre = pkgs.writeShellScript "qbittorrent-setup" ''
        # Wait for Tailscale to be ready
        until tailscale status &>/dev/null; do sleep 1; done
        TSIP=$(tailscale ip -4)
        CONF_DIR="/var/lib/qbittorrent/.config/qBittorrent"
        CONF_FILE="$CONF_DIR/qBittorrent.conf"
        mkdir -p "$CONF_DIR"
        # Remove existing settings we manage
        if [ -f "$CONF_FILE" ]; then
          sed -i '/WebUI\\Address=/d; /WebUI\\HostHeaderValidation=/d' "$CONF_FILE"
          sed -i '/Session\\Interface=/d; /Session\\InterfaceAddress=/d; /Session\\InterfaceName=/d; /Session\\DefaultSavePath=/d' "$CONF_FILE"
        fi
        # Add or update [Preferences] section for WebUI
        if [ -f "$CONF_FILE" ] && grep -q "^\[Preferences\]" "$CONF_FILE"; then
          sed -i '/^\[Preferences\]/a WebUI\\Address='"$TSIP"'\nWebUI\\HostHeaderValidation=false' "$CONF_FILE"
        else
          cat >> "$CONF_FILE" << EOF

        [Preferences]
        WebUI\Address=$TSIP
        WebUI\HostHeaderValidation=false
        EOF
        fi
        # Add or update [BitTorrent] section for VPN binding
        if [ -f "$CONF_FILE" ] && grep -q "^\[BitTorrent\]" "$CONF_FILE"; then
          sed -i '/^\[BitTorrent\]/a Session\\Interface=wg-mullvad\nSession\\InterfaceAddress=10.71.159.207\nSession\\InterfaceName=wg-mullvad\nSession\\DefaultSavePath=/mnt/storagebox/downloads' "$CONF_FILE"
        else
          cat >> "$CONF_FILE" << EOF

        [BitTorrent]
        Session\Interface=wg-mullvad
        Session\InterfaceAddress=10.71.159.207
        Session\InterfaceName=wg-mullvad
        Session\DefaultSavePath=/mnt/storagebox/downloads
        EOF
        fi
        # Ensure download directory exists
        mkdir -p /mnt/storagebox/downloads
      '';
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8181";
      Restart = "on-failure";
      StateDirectory = "qbittorrent";
    };
  };

  environment.systemPackages = [pkgs.qbittorrent-nox];

  # Disable reverse path filtering for VPN interface (required for split tunneling)
  networking.firewall.checkReversePath = "loose";
}

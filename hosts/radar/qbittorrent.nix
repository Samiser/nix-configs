{
  config,
  pkgs,
  ...
}:
let
  vpnInterface = "wg-mullvad";
in
{
  age.secrets.mullvad-privkey = {
    file = ../../secrets/mullvad-privkey.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  networking = {
    wg-quick.interfaces.${vpnInterface} = {
      address = [ "10.71.159.207/32" ];
      privateKeyFile = config.age.secrets.mullvad-privkey.path;

      peers = [
        {
          publicKey = "2S3G7Sm9DVG6+uJtlDu4N6ed5V97sTbA5dCSkUelWyk=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "193.138.7.137:51820";
          persistentKeepalive = 25;
        }
      ];

      table = "51820";
      postUp = ''
        ${pkgs.iproute2}/bin/ip rule add uidrange 888-888 to 100.64.0.0/10 lookup 52 priority 5208
        ${pkgs.iproute2}/bin/ip rule add uidrange 888-888 table 51820 priority 5209
      '';
      postDown = ''
        ${pkgs.iproute2}/bin/ip rule del uidrange 888-888 to 100.64.0.0/10 lookup 52 priority 5208 || true
        ${pkgs.iproute2}/bin/ip rule del uidrange 888-888 table 51820 priority 5209 || true
      '';
    };
    firewall = {
      interfaces.tailscale0.allowedTCPPorts = [ 8181 ];
      checkReversePath = "loose";
    };
  };

  users.users.qbittorrent = {
    isSystemUser = true;
    uid = 888;
    group = "qbittorrent";
    extraGroups = [ "radarr" ];
    home = "/var/lib/qbittorrent";
    createHome = true;
  };
  users.groups.qbittorrent.gid = 888;

  systemd.services.qbittorrent = {
    description = "qBittorrent-nox";
    after = [
      "network.target"
      "wg-quick-${vpnInterface}.service"
    ];
    wants = [ "wg-quick-${vpnInterface}.service" ];
    wantedBy = [ "multi-user.target" ];

    path = [ pkgs.gnused ];

    serviceConfig = {
      Type = "simple";
      User = "qbittorrent";
      Group = "qbittorrent";
      ExecStartPre = pkgs.writeShellScript "qbittorrent-setup" ''
        CONF_DIR="/var/lib/qbittorrent/.config/qBittorrent"
        CONF_FILE="$CONF_DIR/qBittorrent.conf"
        mkdir -p "$CONF_DIR"
        if [ -f "$CONF_FILE" ]; then
          sed -i '/WebUI\\Address=/d; /WebUI\\HostHeaderValidation=/d' "$CONF_FILE"
          sed -i '/Session\\Interface=/d; /Session\\InterfaceAddress=/d; /Session\\InterfaceName=/d; /Session\\DefaultSavePath=/d' "$CONF_FILE"
        fi
        if [ -f "$CONF_FILE" ] && grep -q "^\[Preferences\]" "$CONF_FILE"; then
          sed -i '/^\[Preferences\]/a WebUI\\HostHeaderValidation=false' "$CONF_FILE"
        else
          cat >> "$CONF_FILE" << EOF

        [Preferences]
        WebUI\HostHeaderValidation=false
        EOF
        fi
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
        mkdir -p /mnt/storagebox/downloads
      '';
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8181";
      Restart = "on-failure";
      StateDirectory = "qbittorrent";
    };
  };

}

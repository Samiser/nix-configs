{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.host.profile.server {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      extraFlags = [ "--collector.textfile.directory=/var/lib/prometheus-textfiles" ];
    };

    systemd.tmpfiles.rules = [ "d /var/lib/prometheus-textfiles 0755 root root -" ];

    systemd.services.current-system-metric = {
      script = ''
        printf 'nixos_current_system{path="%s"} 1\n' "$(readlink -f /run/current-system)" \
          > /var/lib/prometheus-textfiles/current-system.prom.tmp
        mv /var/lib/prometheus-textfiles/current-system.prom.tmp \
          /var/lib/prometheus-textfiles/current-system.prom
      '';
      serviceConfig.Type = "oneshot";
    };
    systemd.timers.current-system-metric = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
      };
    };

    services.alloy.enable = true;
    environment.etc."alloy/config.alloy".text = ''
      discovery.relabel "journal" {
        targets = []
        rule {
          source_labels = ["__journal__systemd_unit"]
          target_label  = "unit"
        }
        rule {
          source_labels = ["__journal__hostname"]
          target_label  = "host"
        }
      }

      loki.source.journal "journal" {
        relabel_rules = discovery.relabel.journal.rules
        forward_to    = [loki.write.victorialogs.receiver]
      }

      loki.write "victorialogs" {
        endpoint {
          url = "http://argus:9428/insert/loki/api/v1/push?_stream_fields=host,unit"
        }
      }
    '';

    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 9100 ];
  };
}

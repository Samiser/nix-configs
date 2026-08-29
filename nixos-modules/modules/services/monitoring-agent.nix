{
  config,
  lib,
  ...
}:
let
  cfg = config.services.monitoring-agent;
in
{
  options.services.monitoring-agent = {
    enable = lib.mkEnableOption "node metrics and journal log shipping to argus";
  };

  config = lib.mkIf cfg.enable {
    services.prometheus.exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      extraFlags = [
        "--collector.textfile.directory=/var/lib/prometheus-textfiles"
        "--collector.systemd.enable-restarts-metrics"
      ];
    };

    systemd = {
      tmpfiles.rules = [ "d /var/lib/prometheus-textfiles 0755 root root -" ];

      services.current-system-metric = {
        script = ''
          reboot_required=0
          for f in kernel initrd kernel-modules; do
            if [ "$(readlink -f /run/booted-system/$f)" != "$(readlink -f /run/current-system/$f)" ]; then
              reboot_required=1
            fi
          done
          {
            printf 'nixos_current_system{path="%s"} 1\n' "$(readlink -f /run/current-system)"
            printf 'nixos_reboot_required %s\n' "$reboot_required"
          } > /var/lib/prometheus-textfiles/current-system.prom.tmp
          mv /var/lib/prometheus-textfiles/current-system.prom.tmp \
            /var/lib/prometheus-textfiles/current-system.prom
        '';
        serviceConfig.Type = "oneshot";
      };
      timers.current-system-metric = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1m";
          OnUnitActiveSec = "1m";
        };
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
        rule {
          source_labels = ["__journal_priority_keyword"]
          target_label  = "level"
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

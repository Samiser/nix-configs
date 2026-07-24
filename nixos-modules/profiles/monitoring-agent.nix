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
      extraFlags = [ "--collector.textfile.directory=/etc/prometheus-textfiles" ];
    };

    environment.etc."prometheus-textfiles/nixos.prom".text = ''
      nixos_configuration_info{rev="${toString config.system.configurationRevision}"} 1
    '';

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

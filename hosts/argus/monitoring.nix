{
  config,
  pkgs,
  ...
}:
let
  serverHosts = [
    "argus"
    "jelly"
    "minecraft"
    "nix-lab"
    "radar"
  ];
in
{
  services.victoriametrics = {
    enable = true;
    listenAddress = "127.0.0.1:8428";
    retentionPeriod = "1y";
    prometheusConfig = {
      global.scrape_interval = "30s";
      scrape_configs = [
        {
          job_name = "node";
          static_configs = map (h: {
            targets = [ "${h}:9100" ];
            labels.host = h;
          }) serverHosts;
        }
      ];
    };
  };

  services.victorialogs = {
    enable = true;
    listenAddress = ":9428";
    extraOptions = [ "-retentionPeriod=90d" ];
  };

  age.secrets.grafana-secret-key = {
    file = ../../secrets/grafana-secret-key.age;
    owner = "grafana";
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_addr = "0.0.0.0";
      http_port = 3000;
    };
    settings.security.secret_key = "$__file{${config.age.secrets.grafana-secret-key.path}}";
    declarativePlugins = with pkgs.grafanaPlugins; [
      victoriametrics-logs-datasource
      victoriametrics-metrics-datasource
    ];
    provision.datasources.settings.datasources = [
      {
        name = "VictoriaMetrics";
        type = "prometheus";
        url = "http://127.0.0.1:8428";
        isDefault = true;
      }
      {
        name = "VictoriaLogs";
        type = "victoriametrics-logs-datasource";
        url = "http://127.0.0.1:9428";
      }
    ];
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    3000
    9428
  ];
}

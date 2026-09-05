{
  config,
  pkgs,
  serverHostNames,
  ...
}:
{
  age.secrets.grafana-secret-key = {
    file = ../../secrets/grafana-secret-key.age;
    owner = "grafana";
  };

  services = {
    victoriametrics = {
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
            }) serverHostNames;
          }
          {
            job_name = "monitoring";
            static_configs = [
              {
                targets = [ "127.0.0.1:8428" ];
                labels = {
                  host = "argus";
                  service = "victoriametrics";
                };
              }
              {
                targets = [ "127.0.0.1:9428" ];
                labels = {
                  host = "argus";
                  service = "victorialogs";
                };
              }
              {
                targets = [ "127.0.0.1:3000" ];
                labels = {
                  host = "argus";
                  service = "grafana";
                };
              }
            ];
          }
        ];
      };
    };

    victorialogs = {
      enable = true;
      listenAddress = ":9428";
      extraOptions = [ "-retentionPeriod=90d" ];
    };

    grafana = {
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
      provision.dashboards.settings.providers = [
        {
          name = "nix-configs";
          options.path = ./dashboards;
        }
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
  };

  systemd.services.expected-systems-import = {
    path = [
      pkgs.gitMinimal
      pkgs.nix
      pkgs.jq
      pkgs.curl
    ];
    script = ''
      rev=$(git ls-remote https://github.com/samiser/nix-configs refs/heads/main | cut -f1)
      [ -n "$rev" ]
      state=$STATE_DIRECTORY/last-rev
      cache=$STATE_DIRECTORY/expected.prom

      if [ ! -s "$cache" ] || [ "$(cat "$state" 2>/dev/null)" != "$rev" ]; then
        flake="github:samiser/nix-configs/$rev"
        hosts=$(nix eval --json "$flake#nixosConfigurations" --apply \
          'cfgs: builtins.filter (h: cfgs.''${h}.config.host.profile.server) (builtins.attrNames cfgs)' \
          | jq -r '.[]')

        : > "$cache.tmp"
        for h in $hosts; do
          path=$(nix eval --raw "$flake#nixosConfigurations.$h.config.system.build.toplevel.outPath")
          printf 'nixos_expected_system{host="%s",path="%s"} 1\n' "$h" "$path" >> "$cache.tmp"
        done
        mv "$cache.tmp" "$cache"

        curl -fs -X POST \
          'http://127.0.0.1:8428/api/v1/admin/tsdb/delete_series?match[]=nixos_expected_system'
        echo "$rev" > "$state"
      fi

      curl -fs --data-binary "@$cache" \
        'http://127.0.0.1:8428/api/v1/import/prometheus'
    '';
    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "expected-systems";
      TimeoutStartSec = "30m";
    };
  };
  systemd.timers.expected-systems-import = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "2m";
    };
  };

  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    3000
    9428
  ];
}

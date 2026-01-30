{
  config,
  lib,
  ...
}:
let
  cfg = config.services.miniflux-local;
in {
  options.services.miniflux-local = {
    enable = lib.mkEnableOption "miniflux RSS reader with local caddy routing";

    host = lib.mkOption {
      type = lib.types.str;
      description = "Hostname for caddy routing (e.g., nix-lab)";
      example = "nix-lab";
    };

    path = lib.mkOption {
      type = lib.types.str;
      default = "/miniflux";
      description = "URL path to serve miniflux on";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port miniflux listens on";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = config.services.caddy.enable;
      message = "services.miniflux-local requires caddy to be enabled";
    }];

    age.secrets.miniflux-admin-credentials = {
      file = ../../../secrets/miniflux-admin-credentials.age;
    };

    services.miniflux = {
      enable = true;
      adminCredentialsFile = config.age.secrets.miniflux-admin-credentials.path;
      config = {
        LISTEN_ADDR = "127.0.0.1:${toString cfg.port}";
        BASE_URL = "http://${cfg.host}${cfg.path}";
      };
    };

    services.caddy.virtualHosts."http://${cfg.host}".extraConfig = ''
      reverse_proxy ${cfg.path}* http://127.0.0.1:${toString cfg.port}
    '';
  };
}

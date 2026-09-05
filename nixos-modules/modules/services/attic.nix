{
  config,
  lib,
  sharedLib,
  ...
}:
let
  inherit (sharedLib) cloudflareTls requiresCaddy;
  cfg = config.services.attic-cache;
in
{
  options.services.attic-cache = {
    enable = lib.mkEnableOption "Attic binary cache server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "cache.samiser.xyz";
      description = "Domain to serve the cache on";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "Port atticd listens on";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [ (requiresCaddy config "attic-cache") ];

    age.secrets.attic-jwt-secret = {
      file = ../../../secrets/attic-jwt-secret.age;
    };

    services = {
      postgresql = {
        enable = true;
        ensureDatabases = [ "atticd" ];
        ensureUsers = [
          {
            name = "atticd";
            ensureDBOwnership = true;
          }
        ];
      };

      atticd = {
        enable = true;
        environmentFile = config.age.secrets.attic-jwt-secret.path;
        settings = {
          listen = "127.0.0.1:${toString cfg.port}";
          database.url = "postgres://atticd@localhost/atticd?host=/run/postgresql";
          storage = {
            type = "local";
            path = "/mnt/storagebox/attic";
          };
          compression = {
            type = "zstd";
          };
          chunking = {
            nar-size-threshold = 65536;
            min-size = 16384;
            avg-size = 65536;
            max-size = 262144;
          };
        };
      };

      caddy.virtualHosts.${cfg.domain}.extraConfig = cloudflareTls ''
        reverse_proxy http://127.0.0.1:${toString cfg.port}
      '';
    };

    systemd.services.atticd = {
      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
    };
  };
}

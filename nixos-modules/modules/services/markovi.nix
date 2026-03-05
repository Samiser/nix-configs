{
  config,
  lib,
  markovi,
  pkgs,
  ...
}: let
  cfg = config.services.markovi;
in {
  options.services.markovi = {
    enable = lib.mkEnableOption "markovi Discord bot";

    redisUrl = lib.mkOption {
      type = lib.types.str;
      default = "redis://localhost:6379/0";
      description = "Redis connection URL";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.markovi-discord-token = {
      file = ../../../secrets/markovi-discord-token.age;
    };

    services.redis.servers.markovi = {
      enable = true;
      port = 6379;
    };

    systemd.services.markovi = {
      description = "Markovi Discord Bot";
      wantedBy = ["multi-user.target"];
      after = ["network.target" "redis-markovi.service"];
      requires = ["redis-markovi.service"];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = "${markovi.packages.${pkgs.system}.default}/bin/markovi";
        Restart = "always";
        RestartSec = 10;
        EnvironmentFile = config.age.secrets.markovi-discord-token.path;
        Environment = "REDIS_URL=${cfg.redisUrl}";
      };
    };
  };
}

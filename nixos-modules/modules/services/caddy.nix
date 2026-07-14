{
  config,
  lib,
  pkgs,
  ...
}: let
  caddyCfg = config.services.caddy;
in {
  config = lib.mkIf caddyCfg.enable {
    networking.firewall.allowedTCPPorts = [80 443];

    age.secrets.caddy-cloudflare-key = {
      file = ../../../secrets/caddy-cloudflare-key.age;
      owner = caddyCfg.user;
      inherit (caddyCfg) group;
    };

    systemd.services.caddy.serviceConfig = {
      EnvironmentFile = config.age.secrets.caddy-cloudflare-key.path;
    };

    services.caddy.package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
      hash = "sha256-7g8zDx5RhbptXFyEPtexxkHX8hw/gF001bZ7wX4Mjhs=";
    };
  };
}

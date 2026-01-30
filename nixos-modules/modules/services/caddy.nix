{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [80 443];

  age.secrets.caddy-cloudflare-key = {
    file = ../../../secrets/caddy-cloudflare-key.age;
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.age.secrets.caddy-cloudflare-key.path;
  };

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
      hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
    };
  };
}

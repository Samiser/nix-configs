{
  config,
  pkgs,
  ...
}: let
  tlsConf = ''
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }
  '';
in {
  networking.firewall.allowedTCPPorts = [80 443];

  age.secrets.caddy-cloudflare-key = {
    file = ../../secrets/caddy-cloudflare-key.age;
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  systemd.services.caddy.serviceConfig = {
    EnvironmentFile = config.age.secrets.caddy-cloudflare-key.path;
  };

  services.caddy = {
    enable = true;
    virtualHosts."samiser.xyz www.samiser.xyz".extraConfig = ''
      ${tlsConf}
      root * /srv/blog
      file_server
    '';
    virtualHosts."*.samiser.xyz".extraConfig = ''
      ${tlsConf}
      respond "there's nothing here"
    '';
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/caddy-dns/cloudflare@v0.2.2"];
      hash = "sha256-ea8PC/+SlPRdEVVF/I3c1CBprlVp1nrumKM5cMwJJ3U=";
    };
  };
}

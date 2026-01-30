{
  config,
  ...
}: {
  age.secrets.miniflux-admin-credentials = {
    file = ../../secrets/miniflux-admin-credentials.age;
  };

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux-admin-credentials.path;
    config = {
      LISTEN_ADDR = "127.0.0.1:8080";
      BASE_URL = "http://nix-lab/miniflux";
    };
  };

  services.caddy.virtualHosts."http://nix-lab".extraConfig = ''
    reverse_proxy /miniflux* http://127.0.0.1:8080
  '';
}

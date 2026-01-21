{
  config,
  pkgs,
  ...
}: let
  containerPort = 5000;
in {
  virtualisation.oci-containers.containers.gpa-calc = {
    image = "ghcr.io/samiser/corona-gpa-calculator:latest";
    autoStart = true;
    ports = ["127.0.0.1:${toString containerPort}:${toString containerPort}"];
  };

  services.caddy.virtualHosts."gpa-calc.samiser.xyz".extraConfig = ''
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }
    reverse_proxy localhost:${toString containerPort}
  '';
}

{
  requiresCaddy = config: name: {
    assertion = config.services.caddy.enable;
    message = "services.${name} requires caddy to be enabled";
  };

  cloudflareTls = extraConfig: ''
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }
    ${extraConfig}
  '';
}

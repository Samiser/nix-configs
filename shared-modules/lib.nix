{
  cloudflareTls = extraConfig: ''
    tls {
      dns cloudflare {env.CF_API_TOKEN}
      resolvers 1.1.1.1
    }
    ${extraConfig}
  '';
}

{config, ...}: {
  age.secrets.tailscale-auth-key.file = ../../secrets/tailscale-auth-key.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-auth-key.path;
  };
}

{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.host.profile.server {
    age.secrets.tailscale-auth-key.file = ../../secrets/tailscale-auth-key.age;

    services.tailscale.authKeyFile = config.age.secrets.tailscale-auth-key.path;
  };
}

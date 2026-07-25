{
  config,
  lib,
  ...
}: let
  cfg = config.services.tailscale-auth;
in {
  options.services.tailscale-auth = {
    enable = lib.mkEnableOption "automatic tailscale authentication via agenix key";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.tailscale-auth-key.file = ../../../secrets/tailscale-auth-key.age;

    services.tailscale.authKeyFile = config.age.secrets.tailscale-auth-key.path;
  };
}

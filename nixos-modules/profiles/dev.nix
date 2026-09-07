{ config, lib, ... }:
{
  config = lib.mkIf config.host.profile.dev {
    virtualisation.docker.enable = true;
  };
}

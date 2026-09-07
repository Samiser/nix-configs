{ lib, osConfig, ... }:
{
  config = lib.mkIf (!osConfig.host.profile.server) {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Samiser";
        email = "github@me.samiser.xyz";
      };
    };
  };
}

{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        settings = {
          cpu = 4;
          memory = 8;
          vmType = "vz";
        };
      };
    };
  };
}

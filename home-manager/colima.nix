{
  lib,
  config,
  ...
}:
let
  cfg = config.sam.colima;
in
{
  options.sam.colima.enable = lib.mkEnableOption "colima container runtime";

  config = lib.mkIf cfg.enable {
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

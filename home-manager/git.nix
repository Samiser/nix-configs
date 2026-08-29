{
  lib,
  config,
  ...
}:
let
  cfg = config.sam.git;
in
{
  options.sam.git.enable = lib.mkEnableOption "git config";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Samiser";
        email = "github@me.samiser.xyz";
      };
    };
  };
}

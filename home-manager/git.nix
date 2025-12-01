{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.sam.git;
in {
  options.sam.git.enable = mkEnableOption "git config";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user = {
        name = "Samiser";
        email = "github@me.samiser.xyz";
      };
    };
  };
}

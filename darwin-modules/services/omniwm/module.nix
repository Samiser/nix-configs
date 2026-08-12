{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.omniwm;
in
{
  options.services.omniwm = {
    enable = lib.mkEnableOption "the OmniWM window manager";

    package = lib.mkPackageOption pkgs "omniwm" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.omniwm = {
      serviceConfig = {
        ProgramArguments = [ "${cfg.package}/Applications/OmniWM.app/Contents/MacOS/OmniWM" ];
        KeepAlive = true;
        RunAtLoad = true;
      };
      managedBy = "services.omniwm.enable";
    };
  };
}

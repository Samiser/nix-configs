{
  config,
  lib,
  pkgs,
  mango,
  ...
}:
let
  cfg = config.hostConfig.mango;
in
{
  imports = [ mango.nixosModules.mango ];

  options.hostConfig.mango.enable = lib.mkEnableOption "Mango Wayland compositor";

  config = lib.mkIf cfg.enable {
    programs.mango.enable = true;

    xdg.portal.wlr.settings.screencast = {
      chooser_type = "dmenu";
      chooser_cmd = "${pkgs.fuzzel}/bin/fuzzel -d -l 10 -p 'Select a source to share: '";
    };
  };
}

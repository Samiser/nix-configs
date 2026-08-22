{
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.umbriel;
in
{
  imports = [ ./module.nix ];

  options.hostConfig.umbriel.enable = lib.mkEnableOption "Umbriel Wayland compositor";

  config = lib.mkIf cfg.enable {
    programs.umbriel.enable = true;
  };
}

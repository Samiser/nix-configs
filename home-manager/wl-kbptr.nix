{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.sam.wl-kbptr;
in
{
  options.sam.wl-kbptr.enable = mkEnableOption "wl-kbptr config";

  config = mkIf cfg.enable {
    xdg.configFile."wl-kbptr/config".text = ''
      [general]
      modes=floating,click

      [mode_floating]
      source=detect
    '';
  };
}

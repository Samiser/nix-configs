{
  lib,
  config,
  ...
}:
let
  cfg = config.sam.wl-kbptr;
in
{
  options.sam.wl-kbptr.enable = lib.mkEnableOption "wl-kbptr config";

  config = lib.mkIf cfg.enable {
    xdg.configFile."wl-kbptr/config".text = ''
      [general]
      modes=floating,click

      [mode_floating]
      source=detect
    '';
  };
}

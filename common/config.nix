{ config, lib, pkgs, ... }:

with lib; {
  options.hostConfig = { 
    gui.enable = mkEnableOption "enable GUI programs";
  };
}

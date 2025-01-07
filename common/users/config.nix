{ config, lib, pkgs, ... }:

{
  options.gui = { 
    enable = lib.mkEnableOption "enable GUI programs";
  };
}

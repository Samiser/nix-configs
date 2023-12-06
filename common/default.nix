{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ./users
    ./users/home-manager.nix
    ./modules
  ];

  options.hostConfig = { 
    gui.enable = mkEnableOption "enable GUI programs";
  };
}

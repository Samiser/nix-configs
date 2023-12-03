{ config, lib, pkgs, ... }:

with lib; {
  imports = [
    ./users
    ./users/home-manager.nix
    ./nixos/programs/i3.nix
    ./nixos/programs/pkgs.nix
    ./nixos/services
  ];

  options.hostConfig = { gui.enable = mkEnableOption "enable GUI programs"; };
}

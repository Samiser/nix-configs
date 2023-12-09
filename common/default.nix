{ config, lib, pkgs, ... }:

{
  imports = [
    ./users
    ./users/home-manager.nix
    ./modules
    ./config.nix
  ];
}

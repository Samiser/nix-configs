{ config, lib, pkgs, ... }:

{
  imports = [
    ./users
    ./modules
    ./config.nix
  ];
}

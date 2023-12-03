{ config, pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  home-manager.users.sam = (import ./sam);
}

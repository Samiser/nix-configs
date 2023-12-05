{ config, pkgs, home-manager, ... }:

{
  imports = [ home-manager.nixosModules.default ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.sam = (import ./sam);
}

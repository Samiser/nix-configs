{
  agenix,
  closured,
  home-manager,
  waypak,
  ...
}:
let
  keys = import ../shared-modules/keys.nix;
  sharedLib = import ../shared-modules/lib.nix;
in
{
  nixos = [
    { _module.args = { inherit keys sharedLib; }; }
    ../nixos-modules/modules
    ../nixos-modules/profiles
    ../shared-modules/host.nix
    ../shared-modules/nix.nix
    ../shared-modules/packages.nix
    agenix.nixosModules.default
    closured.nixosModules.default
    waypak.nixosModules.default
    home-manager.nixosModules.default
    { imports = [ ../home-manager/home.nix ]; }
  ];

  darwin = [
    { _module.args = { inherit keys sharedLib; }; }
    ../darwin-modules
    ../shared-modules/host.nix
    ../shared-modules/nix.nix
    ../shared-modules/packages.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    { imports = [ ../home-manager/home.nix ]; }
  ];
}

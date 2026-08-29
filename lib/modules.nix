{
  agenix,
  closured,
  home-manager,
  ...
}:
let
  keys = import ../shared-modules/keys.nix;
  sharedPackages = import ../shared-modules/packages.nix;
  sharedLib = import ../shared-modules/lib.nix;
in
{
  nixos = [
    { _module.args = { inherit keys sharedPackages sharedLib; }; }
    ../nixos-modules/modules
    ../nixos-modules/profiles
    ../shared-modules/nix.nix
    agenix.nixosModules.default
    closured.nixosModules.default
    home-manager.nixosModules.default
    { imports = [ ../home-manager/home.nix ]; }
  ];

  darwin = [
    { _module.args = { inherit keys sharedPackages sharedLib; }; }
    ../darwin-modules
    ../shared-modules/nix.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    { imports = [ ../home-manager/home.nix ]; }
  ];
}

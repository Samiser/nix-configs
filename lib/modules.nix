{
  agenix,
  home-manager,
  self,
  ...
}: let
  keys = import ../shared-modules/keys.nix;
  sharedPackages = import ../shared-modules/packages.nix;
in {
  nixos = [
    {_module.args = {inherit keys sharedPackages;};}
    {system.configurationRevision = self.rev or "dirty";}
    ../nixos-modules/modules
    ../nixos-modules/profiles
    ../shared-modules/nix.nix
    agenix.nixosModules.default
    home-manager.nixosModules.default
    {imports = [../home-manager/home.nix];}
  ];

  darwin = [
    {_module.args = {inherit keys sharedPackages;};}
    ../darwin-modules
    ../shared-modules/nix.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    {imports = [../home-manager/darwin.nix];}
  ];
}

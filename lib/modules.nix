{
  agenix,
  home-manager,
  ...
}: let
  keys = import ../shared-modules/keys.nix;
in {
  nixos = [
    {_module.args = {inherit keys;};}
    ../nixos-modules/modules
    ../nixos-modules/profiles
    ../shared-modules/garnix.nix
    agenix.nixosModules.default
    home-manager.nixosModules.default
    {imports = [../home-manager/home.nix];}
  ];

  darwin = [
    {_module.args = {inherit keys;};}
    ../darwin-modules
    ../shared-modules/garnix.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    {imports = [../home-manager/darwin.nix];}
  ];
}

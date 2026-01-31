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
    ../shared-modules/nix.nix
    agenix.nixosModules.default
    home-manager.nixosModules.default
    {imports = [../home-manager/home.nix];}
  ];

  darwin = [
    {_module.args = {inherit keys;};}
    ../darwin-modules
    ../shared-modules/nix.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    {imports = [../home-manager/darwin.nix];}
  ];
}

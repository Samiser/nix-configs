{
  agenix,
  home-manager,
  ...
}: {
  nixos = [
    ../nixos-modules/modules
    ../nixos-modules/profiles
    ../shared-modules/garnix.nix
    agenix.nixosModules.default
    home-manager.nixosModules.default
    {imports = [../home-manager/home.nix];}
  ];

  darwin = [
    ../darwin-modules
    ../shared-modules/garnix.nix
    agenix.darwinModules.default
    home-manager.darwinModules.default
    {imports = [../home-manager/darwin.nix];}
  ];
}

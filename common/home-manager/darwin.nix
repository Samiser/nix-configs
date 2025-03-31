{home-manager, ...}: {
  imports = [
    home-manager.darwinModules.home-manager
    {
      imports = [./home.nix];
    }
  ];
}

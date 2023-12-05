{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.imperium = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./hosts/imperium/configuration.nix ];
    };
  };
}

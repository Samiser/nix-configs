{
  inputs.nixpkgs.url = github:nixos/nixpkgs/release-23.05;

  outputs = { self, nixpkgs }: {
    nixosConfigurations.imperium = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}

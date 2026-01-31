{inputs}: let
  modules = import ./modules.nix inputs;
  hosts = import ./hosts.nix {inherit inputs modules;};
  deploy = import ./deploy.nix {
    inherit inputs;
    inherit (hosts) nixosConfigurations;
  };
  shells = import ./shells.nix {inherit inputs;};
in {
  inherit (hosts) nixosConfigurations darwinConfigurations;
  inherit (deploy) deploy;
  devShells = shells;
}

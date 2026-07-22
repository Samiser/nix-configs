{inputs}: let
  modules = import ./modules.nix inputs;
  hosts = import ./hosts.nix {inherit inputs modules;};
  deploy = import ./deploy.nix {
    inherit inputs;
    inherit (hosts) nixosConfigurations;
  };
  shells = import ./shells.nix {inherit inputs;};
  ci = import ./ci.nix {
    inherit (hosts) nixosConfigurations darwinConfigurations;
    devShells = shells;
  };
in {
  inherit (hosts) nixosConfigurations darwinConfigurations;
  inherit (deploy) deploy;
  inherit (ci) checks;
  devShells = shells;
}

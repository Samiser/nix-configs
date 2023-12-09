{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs, deploy-rs, ... }@attrs: let
    mkSystem = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./hosts/${hostname}/configuration.nix ];
    };
    mkNode = hostname: {
      inherit hostname;
      sshUser = "root";
      magicRollback = false;

      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${hostname};
      };
    };
  in
  {
    nixosConfigurations = {
      imperium = mkSystem "imperium";
      nix-lab = mkSystem "nix-lab";
      lazarus-wsl = mkSystem "lazarus-wsl";
    };

    deploy.nodes = {
      imperium = mkNode "imperium";
      nix-lab = mkNode "nix-lab";
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    deploy-rs.url = "github:serokell/deploy-rs";
    agenix.url = "github:ryantm/agenix";
    my-neovim.url = "github:Samiser/neovim-config";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    my-neovim,
    ...
  } @ attrs: let
    mkSystem = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs // {inherit my-neovim;};
        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
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
  in {
    nixosConfigurations = {
      imperium = mkSystem "imperium";
      nix-lab = mkSystem "nix-lab";
      lazarus-wsl = mkSystem "lazarus-wsl";
    };

    deploy.nodes = {
      nix-lab = mkNode "nix-lab";
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}

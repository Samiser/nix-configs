{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    my-neovim.url = "github:Samiser/neovim-config";
    nix-darwin.url = "github:LnL7/nix-darwin";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    home-manager,
    my-neovim,
    ...
  } @ attrs: let
    mkSystem = hostname: system: let
      isDarwin = builtins.match ".*-darwin" system != null;
      builder =
        if isDarwin
        then nix-darwin.lib.darwinSystem
        else nixpkgs.lib.nixosSystem;
    in
      builder {
        inherit system;
        specialArgs = attrs // {inherit my-neovim;};
        modules =
          [
            ./hosts/${hostname}/configuration.nix
          ]
          ++ nixpkgs.lib.optional isDarwin home-manager.darwinModules.home-manager;
      };
  in {
    nixosConfigurations = {
      imperium = mkSystem "imperium" "x86_64-linux";
      nix-lab = mkSystem "nix-lab" "x86_64-linux";
      lazarus-wsl = mkSystem "lazarus-wsl" "x86_64-linux";
    };

    darwinConfigurations = {
      beanbook = mkSystem "beanbook" "aarch64-darwin";
    };
  };
}

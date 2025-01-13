{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    agenix.url = "github:ryantm/agenix";
    my-neovim.url = "github:Samiser/neovim-config";
  };

  outputs = {
    nixpkgs,
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
  in {
    nixosConfigurations = {
      "x86_64-linux" = {
        imperium = mkSystem "imperium";
        nix-lab = mkSystem "nix-lab";
        lazarus-wsl = mkSystem "lazarus-wsl";
      };
    };
  };
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/nixos-wsl/main";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    my-neovim.url = "github:Samiser/neovim-config";
    # Tracking: https://github.com/NixOS/nixpkgs/issues/483584
    # my-neovim.inputs.nixpkgs.follows = "nixpkgs";
    static-site-compiler.url = "github:Samiser/static-site-compiler";
    static-site-compiler.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    systems = import ./lib/systems.nix {inherit inputs;};
  in
    systems {inherit inputs;};
}

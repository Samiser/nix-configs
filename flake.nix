{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/master";
      url = "github:samiser/home-manager/launchd-wait-for-nix-store";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:samiser/nix-minecraft/lazymc-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-neovim = {
      url = "github:samiser/neovim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    static-site-compiler = {
      url = "github:samiser/static-site-compiler";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    markovi = {
      url = "github:samiser/markovi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    closured = {
      url = "github:samiser/closured";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: import ./lib {inherit inputs;};
}

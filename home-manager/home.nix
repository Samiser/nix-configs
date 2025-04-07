{
  pkgs,
  config,
  my-neovim,
  agenix,
  ...
}: let
  gui = config.hostConfig.gui.enable;
in {
  home-manager = {
    extraSpecialArgs = {inherit my-neovim;};
    useGlobalPkgs = true;
    useUserPackages = true;

    users.sam = {
      imports = [
        agenix.homeManagerModules.default
        ./hcloud.nix
        ./alacritty.nix
        ./sketchybar
        ./git.nix
        ./i3
        ./neovim.nix
        ./pywal.nix
        ./zsh
      ];

      home = {
        username = "sam";
        homeDirectory =
          if pkgs.stdenv.isDarwin
          then "/Users/sam"
          else "/home/sam";

        stateVersion = "25.05";
      };

      sam = {
        zsh.enable = true;
        git.enable = true;
        neovim.enable = true;
        sketchybar.enable = pkgs.stdenv.isDarwin;
        alacritty.enable = pkgs.stdenv.isLinux && gui;
        i3.enable = pkgs.stdenv.isLinux && gui;
        pywal.enable = pkgs.stdenv.isLinux && gui;
      };
    };
  };
}

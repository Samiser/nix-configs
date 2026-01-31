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
    backupFileExtension = "backup";

    users.sam = {
      imports = [
        agenix.homeManagerModules.default
        ./hcloud.nix
        ./alacritty.nix
        ./git.nix
        ./i3
        ./neovim.nix
        ./ghostty.nix
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
        ghostty.enable = pkgs.stdenv.isDarwin;
        alacritty.enable = pkgs.stdenv.isLinux && gui;
        i3.enable = pkgs.stdenv.isLinux && gui;
      };
    };
  };
}

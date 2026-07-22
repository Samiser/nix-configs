{
  pkgs,
  config,
  my-neovim,
  agenix,
  ...
}: let
  i3 = config.hostConfig.i3.enable;
  hyprland = config.hostConfig.hyprland.enable;
in {
  home-manager = {
    extraSpecialArgs = {inherit my-neovim;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.sam = {
      imports = [
        agenix.homeManagerModules.default
        ./alacritty.nix
        ./colima.nix
        ./ghostty.nix
        ./git.nix
        ./hcloud.nix
        ./i3
        ./neovim.nix
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
        ghostty.enable = pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux && hyprland);
        colima.enable = pkgs.stdenv.isDarwin;
        alacritty.enable = pkgs.stdenv.isLinux && i3;
        i3.enable = pkgs.stdenv.isLinux && i3;
      };

      launchd.agents = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
        activate-agenix.waitForNixStore = false;
        colima-default = {
          waitForNixStore = false;
          domain = "gui";
        };
      };
    };
  };
}

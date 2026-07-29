{
  pkgs,
  config,
  lib,
  my-neovim,
  agenix,
  ...
}: let
  hyprland = config.hostConfig.hyprland.enable;
  server = config.host.profile.server or false;
in {
  home-manager = {
    extraSpecialArgs = {inherit my-neovim;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.sam = {
      imports =
        [
          agenix.homeManagerModules.default
          ./colima.nix
          ./ghostty.nix
          ./git.nix
          ./neovim.nix
          ./zsh
        ]
        ++ lib.optional (!server) ./hcloud.nix;

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
        git.enable = !server;
        neovim.enable = true;
        neovim.minimal = server;
        ghostty.enable = pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux && hyprland);
        colima.enable = pkgs.stdenv.isDarwin;
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

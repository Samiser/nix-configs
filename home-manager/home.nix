{
  pkgs,
  config,
  lib,
  my-neovim,
  agenix,
  mango,
  umbriel,
  ...
}:
let
  desktop = config.host.profile.desktop or false;
  server = config.host.profile.server or false;
in
{
  home-manager = {
    extraSpecialArgs = { inherit my-neovim mango umbriel; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.sam = {
      imports = [
        agenix.homeManagerModules.default
        ./colima.nix
        ./ghostty.nix
        ./git.nix
        ./neovim.nix
        ./mango
        ./umbriel
        ./omniwm
        ./wl-kbptr.nix
        ./zsh
      ]
      ++ lib.optional (!server) ./hcloud.nix;

      home = {
        username = "sam";
        homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/sam" else "/home/sam";

        sessionVariables = {
          EDITOR = "vim";
          VISUAL = "vim";
        };

        stateVersion = "25.05";
      };

      sam = {
        zsh.enable = true;
        git.enable = !server;
        neovim.enable = true;
        neovim.minimal = server;
        ghostty.enable = pkgs.stdenv.hostPlatform.isDarwin || desktop;
        mango.enable = pkgs.stdenv.hostPlatform.isLinux && config.hostConfig.mango.enable;
        umbriel.enable = pkgs.stdenv.hostPlatform.isLinux && config.hostConfig.umbriel.enable;
        colima.enable = pkgs.stdenv.hostPlatform.isDarwin;
        omniwm.enable = pkgs.stdenv.hostPlatform.isDarwin;
        wl-kbptr.enable = pkgs.stdenv.hostPlatform.isLinux && desktop;
      };

      launchd.agents = pkgs.lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        activate-agenix.waitForNixStore = false;
        colima-default = {
          waitForNixStore = false;
          domain = "gui";
        };
      };
    };
  };
}

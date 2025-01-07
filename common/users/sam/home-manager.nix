{ config, pkgs, lib, ... }:

{
  imports = [
    ../../home-manager
    ../config.nix
  ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";

  sam = {
    zsh.enable = true;
    git.enable = true;
    alacritty.enable = true;
    neovim.enable = true;
    i3.enable = config.gui.enable;
    pywal.enable = config.gui.enable;
  };
}

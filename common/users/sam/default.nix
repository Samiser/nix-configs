{ config, pkgs, ... }:

{
  home.username = "sam";
  home.homeDirectory = "/home/sam";

  imports = [ ../../home-manager ];

  sam = {
    zsh.enable = true;
    git.enable = true;
    alacritty.enable = true;
    neovim.enable = true;
    i3.enable = true;
    pywal.enable = true;
  };
}

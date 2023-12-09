{ config, pkgs, ... }:

{
  imports = [ ../../home-manager ];

  home.username = "sam";
  home.homeDirectory = "/home/sam";

  sam = {
    zsh.enable = true;
    git.enable = true;
    alacritty.enable = true;
    neovim.enable = true;
    i3.enable = true;
    pywal.enable = true;
  };
}

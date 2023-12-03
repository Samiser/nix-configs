{ config, pkgs, ... }:
{
  users.mutableUsers = false;

  # Define a user account.
  users.users.sam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "libvirtd" "docker" ];
    hashedPassword = "$6$YvQ.LsWTIYp2jkWe$brA.AICuG4BEvRBchrVmrHwe.6Mr6RgfTcwHBTXTmhjqgVP9Ql5vktY/zPWJc5Y3aEp5EYkFO0fpP/RnUU0dH0";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDq1QymyXXTarJHQYXQ83Tg4ZAy4EeCrQvZ8nq5Rs/9ZK8Gznkc0eVF0rF/dW5P+a2DJPefYfBsaYS6BFxJwkxSLK1m2hk/rXMsAMviWbN4gtsWtLCqk7tl6sEMuxkUfaFwU5rMevdNNC9dgY2J4216xjTBvtXNkMjjAfnOmVUk2lyq1VxgyKyL4JhJvB/ZUGbmf8q07JPnka4VuxEhYkbWxm9e00LJ61QYxRRIYM6xBNsjBp3n+GUUEeWEPJKCvPZGTzIdTXXWUFAAcTOqxAtb9vtvgnbI63HU21A4KXRm1aS+VPusgofb5qP/CXfLUCfMpPadXAyUFH1ZXAchSxH0tPkgb1AWQdBYrXX/aD2/cyQFpZAGPe5JOWHSfPaRpHvOJvErEimVBdZOkhGV10ustcM0kJcZEH2zBOrMJrsD7wr+HNoxC8TdW7YyoCvu3H624WqDxSyvepwx4XbXx1Ezlwec8QWi0JIjTjP9RHaCYAgEk3FBK54Bsq/iX5EIwC0= sam@khaos"
    ];
  };

  home-manager.useGlobalPkgs = true;

  home-manager.users.sam = { config, pkgs, ... }: {
    home.username = "sam";
    home.homeDirectory = "/home/sam";

    imports = [
      ../home-manager
    ];

    sam = {
      zsh.enable = true;
      git.enable = true;
      alacritty.enable = true;
      neovim.enable = true;
      i3.enable = true;
      pywal.enable = true;
    };
  };
}

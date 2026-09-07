{ pkgs, ... }:
{
  host.profile = {
    desktop = true;
    dev = true;
  };

  environment.systemPackages = [
    pkgs._1password-cli
    pkgs.docker

    pkgs._1password-gui
    pkgs.discord
    pkgs.ghostty-bin
    pkgs.google-chrome
    pkgs.obsidian
    pkgs.prismlauncher
    pkgs.spotify

    # macos specific
    pkgs.utm
    pkgs.raycast
    pkgs.iina
  ];

  services.omniwm.enable = true;

  users.users.sam = {
    name = "sam";
    home = "/Users/sam";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [
      "FelixKratz/formulae"
      "gromgit/fuse"
    ];
    brews = [
      "gromgit/fuse/ext4fuse-mac"
    ];
    casks = [
      "macfuse"
      "steam"
      "tailscale-app"
    ];
  };

  networking = {
    computerName = "beanbook";
    hostName = "beanbook";
  };

  nix.settings = {
    trusted-users = [
      "root"
      "sam"
      "@admin"
    ];
  };

  system = {
    primaryUser = "sam";
    stateVersion = 6;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}

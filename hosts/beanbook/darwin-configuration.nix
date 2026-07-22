{
  pkgs,
  my-neovim,
  sharedPackages,
  ...
}: {
  environment.systemPackages =
    (sharedPackages.all {inherit pkgs;})
    ++ [
      my-neovim.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs._1password-gui
      pkgs.discord
      pkgs.ghostty-bin
      pkgs.godot
      pkgs.google-chrome
      pkgs.obsidian
      pkgs.prismlauncher
      pkgs.spotify
    ]
    ++ [
      # macos specific
      pkgs.utm
      pkgs.raycast
      pkgs.iina
    ];

  sam = {
    services = {
      yabai.enable = true;
      jankyborders.enable = true;
      skhd.enable = true;
      codesign.enable = true;
    };
  };

  users.users.sam = {
    name = "sam";
    home = "/Users/sam";
  };

  fonts.packages = with pkgs; [nerd-fonts.jetbrains-mono];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = ["FelixKratz/formulae" "gromgit/fuse"];
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
    trusted-users = ["root" "sam" "@admin"];
  };

  system = {
    primaryUser = "sam";
    stateVersion = 6;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}

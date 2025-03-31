{
  pkgs,
  my-neovim,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # TODO: refactor generic packages out of this config
    _1password-cli
    fd
    my-neovim.packages.${system}.default
    neofetch
    ripgrep
    tailscale
    tmux
    tree
  ];

  imports = [
    ../../common/home-manager/darwin.nix
    ../../common/darwin-modules
  ];

  nix.linux-builder.enable = true;

  sam = {
    services = {
      tailscale.enable = true;
      yabai.enable = true;
      jankyborders.enable = true;
      skhd.enable = true;
    };
  };

  users.users.sam = {
    name = "sam";
    home = "/Users/sam";
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [];
    brews = [];
    casks = [
      "1password"
      "bitwig-studio"
      "colemak-dh"
      "discord"
      "ghostty"
      "godot"
      "google-chrome"
      "obsidian"
      "spotify"
      "utm"
    ];
  };

  networking = {
    computerName = "beanbook";
    hostName = "beanbook";
  };

  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["root" "sam" "@admin"];
    };
  };

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  nixpkgs = {
    # The platform the configuration will be used on.
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
}

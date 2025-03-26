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
    my-neovim.packages.${system}.default
    tmux
    neofetch
    tailscale
  ];

  imports = [
    ../../common/home-manager/darwin.nix
    ../../common/darwin-modules
  ];

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
      "colemak-dh"
      "ghostty"
      "google-chrome"
      "obsidian"
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
      trusted-users = ["root" "sam"];
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

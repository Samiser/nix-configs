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
    tmux
    tree
    ffmpeg
    colima
    docker
  ];

  imports = [
    ../../home-manager/darwin.nix
    ../../darwin-modules
    ../../shared-modules/garnix.nix
  ];

  sam = {
    services = {
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

    taps = ["FelixKratz/formulae"];
    brews = [
      {
        name = "sketchybar";
        start_service = true;
        restart_service = "changed";
      }
    ];
    casks = [
      "tailscale"
      "1password"
      "bitwig-studio"
      "colemak-dh"
      "discord"
      "font-jetbrains-mono-nerd-font"
      "ghostty"
      "gimp"
      "godot"
      "google-chrome"
      "iina"
      "obsidian"
      "raycast"
      "spotify"
      "utm"
    ];
  };

  networking = {
    computerName = "beanbook";
    hostName = "beanbook";
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      sandbox = true;
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

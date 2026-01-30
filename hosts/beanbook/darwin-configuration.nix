{
  pkgs,
  my-neovim,
  ...
}: {
  environment.systemPackages = with pkgs; [
    _1password-cli
    fd
    my-neovim.packages.${stdenv.hostPlatform.system}.default
    neofetch
    ripgrep
    tmux
    tree
    ffmpeg
    colima
    docker
    claude-code
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
    primaryUser = "sam";
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
}

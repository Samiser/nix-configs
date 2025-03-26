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
    git
    my-neovim.packages.${system}.default
    tmux
    neofetch
    font-awesome_5
    tailscale

    # macos-specific
    utm
  ];

  services = {
    tailscale.enable = true;

    yabai = {
      enable = true;
      enableScriptingAddition = true;
      package = pkgs.yabai;
      config = {
        # yabai should manage windows
        layout = "bsp";

        # new window spawns to the right if vertical split, or bottom if horizontal split
        window_placement = "second_child";

        # set all padding and gaps to 20pt
        top_padding = 15;
        bottom_padding = 15;
        left_padding = 15;
        right_padding = 15;
        window_gap = 15;

        # set focus follows mouse mode
        focus_follows_mouse = "autoraise";

        # show shadows only for floating windows
        window_shadow = "float";
      };
      extraConfig = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        yabai -m rule --add app="^System Settings$" manage=off
      '';
    };

    jankyborders = {
      enable = true;
      active_color = "0xffe1e3e4";
      inactive_color = "gradient(top_right=0x9992B3F5,bottom_left=0x9992B3F5)";
    };

    skhd = {
      enable = true;
      skhdConfig = ''
        cmd - return : open -n -a "Ghostty"

        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        lalt - 1 : yabai -m space --focus 1
        lalt - 2 : yabai -m space --focus 2
        lalt - 3 : yabai -m space --focus 3
        lalt - 4 : yabai -m space --focus 4
        lalt - 5 : yabai -m space --focus 5
        lalt - 6 : yabai -m space --focus 6
        lalt - 7 : yabai -m space --focus 7
        lalt - 8 : yabai -m space --focus 8
        lalt - 9 : yabai -m space --focus 9
        lalt - 0  : yabai -m space --focus 10

        shift + lalt - 1 : yabai -m window --space 1
        shift + lalt - 2 : yabai -m window --space 2
        shift + lalt - 3 : yabai -m window --space 3
        shift + lalt - 4 : yabai -m window --space 4
        shift + lalt - 5 : yabai -m window --space 5
        shift + lalt - 6 : yabai -m window --space 6
        shift + lalt - 7 : yabai -m window --space 7
        shift + lalt - 8 : yabai -m window --space 8
        shift + lalt - 9 : yabai -m window --space 9
        shift + lalt - 0 : yabai -m window --space 10

        alt - f : yabai -m window --toggle zoom-fullscreen
      '';
    };
  };

  users.users.sam = {
    name = "sam";
    home = "/Users/sam";
  };

  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [];
    brews = [];
    casks = [
      "colemak-dh"
      "obsidian"
      "google-chrome"
      "ghostty"
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

  nix.settings.experimental-features = "nix-command flakes";

  system = {
    defaults = {
      dock = {
        autohide = true;
        show-recents = false;
        tilesize = 64;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        CreateDesktop = false;
        FXPreferredViewStyle = "Nlsv";
      };

      NSGlobalDomain = {
        NSAutomaticCapitalizationEnabled = false;
        "com.apple.mouse.tapBehavior" = 1;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}

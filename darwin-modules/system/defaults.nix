{
  system.defaults = {
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

    loginwindow.GuestEnabled = false;

    NSGlobalDomain = {
      NSAutomaticCapitalizationEnabled = false;
      "com.apple.mouse.tapBehavior" = 1;
    };

    trackpad = {
      Clicking = true;
      FirstClickThreshold = 0;
    };

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable 'Cmd + Space' for Spotlight Search
          "64".enabled = false;
          # Disable 'Cmd + Alt + Space' for Finder search window
          "65".enabled = false;
        };
      };
    };
  };
}

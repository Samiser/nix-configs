{
  config,
  lib,
  pkgs,
  sharedPackages,
  ...
}: {
  config = lib.mkIf config.host.profile.desktop {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };

    security.rtkit.enable = true;

    networking.networkmanager.enable = true;

    services = {
      upower.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
        font-awesome
      ];
      fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font Mono"];
    };

    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;

      steam = {
        enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamescope.enable = true;
      gamemode.enable = true;

      dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            gtk-theme = "Adwaita";
            icon-theme = "Flat-Remix-Red-Dark";
            font-name = "Noto Sans Medium 11";
            document-font-name = "Noto Sans Medium 11";
            monospace-font-name = "Noto Sans Mono Medium 11";
          };
        }
      ];
    };

    environment.systemPackages =
      (sharedPackages.desktop {inherit pkgs;})
      ++ (with pkgs; [
        acpi
        flat-remix-icon-theme
        ghostty
        gimp
        godot_4
        google-chrome
        imv
        mpv
        mupdf
        nnn
        obsidian
        pavucontrol
        playerctl
        wdisplays
        wf-recorder
      ])
      ++ lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") (with pkgs; [
        spotify-player
        vesktop
      ]);
  };
}

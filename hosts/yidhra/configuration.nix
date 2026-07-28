{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.kernelParams = [ "mem_sleep_default=s2idle" ];

  hostConfig.hyprland.enable = true;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    openssh.enable = true;
    upower.enable = true;
    closured.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
      extraConfig.pipewire."10-mic-input1-mono"."context.modules" = [
        {
          name = "libpipewire-module-loopback";
          args = {
            "node.description" = "Mic (Input 1 mono)";
            "capture.props" = {
              "node.name" = "capture.mic_input1";
              "media.class" = "Stream/Input/Audio";
              "target.object" = "alsa_input.usb-Focusrite_Scarlett_8i6_USB_F854AKF1A0C0FC-00.pro-input-0";
              "audio.position" = [ "AUX0" ];
              "stream.dont-remix" = true;
            };
            "playback.props" = {
              "node.name" = "mic_input1";
              "node.description" = "Mic (Input 1 mono)";
              "media.class" = "Audio/Source";
              "audio.position" = [ "MONO" ];
            };
          };
        }
      ];
    };
  };

  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        kernelSuspendNotifier = false;
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamescope.enable = true;
    gamemode.enable = true;
    noctalia.enable = true;
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

  networking = {
    hostName = "yidhra";
    networkmanager.enable = true;
  };

  security.rtkit.enable = true;

  systemd.services.tailscale-set-operator = {
    description = "Set sam as the Tailscale operator";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.tailscale}/bin/tailscale set --operator=sam";
    };
  };

  environment.systemPackages = with pkgs; [
    claude-code
    fastfetch
    feh
    ghostty
    git
    google-chrome
    mupdf
    neovim
    nnn
    pavucontrol
    spotify-player
    vesktop
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      font-awesome
    ];
  };

  system.stateVersion = "26.05";
}

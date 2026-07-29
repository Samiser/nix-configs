{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  host.profile = {
    desktop = true;
    dev = true;
  };

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
    closured.enable = true;
    pipewire.extraConfig.pipewire."10-mic-input1-mono"."context.modules" = [
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

  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        kernelSuspendNotifier = false;
      };
    };
    graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };

  networking.hostName = "yidhra";

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

  system.stateVersion = "26.05";
}

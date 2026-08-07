{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./nvidia.nix
    ./audio.nix
    ./tailscale.nix
    ./noctalia-greeter.nix
  ];

  host.profile = {
    desktop = true;
    dev = true;
  };

  hostConfig.hyprland = {
    enable = true;
    tuigreet = false;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings.keyboard.layout = "us";
  };

  services = {
    openssh.enable = true;
    closured.enable = true;
  };

  networking.hostName = "yidhra";

  system.stateVersion = "26.05";
}

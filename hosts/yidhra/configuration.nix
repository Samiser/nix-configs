{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./nvidia.nix
    ./audio.nix
    ./tailscale.nix
  ];

  host.profile = {
    desktop = true;
    dev = true;
  };

  hostConfig.hyprland.enable = true;

  services = {
    openssh.enable = true;
    closured.enable = true;
  };

  networking.hostName = "yidhra";

  system.stateVersion = "26.05";
}

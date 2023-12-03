{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # common stuff
    ../../common
    # hardware-specific features
    ../../common/nixos/hardware
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set time zone.
  time.timeZone = "Europe/London";

  # Configure wifi interface
  networking = {
    hostName = "imperium";
    interfaces.wlp59s0.useDHCP = true;
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Console settings
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  # Custom host config
  hostConfig = {
    gui.enable = true;
    i3.enable = true;
    autologin = {
      user = "sam";
      session = "none+i3";
    };
  };

  system.stateVersion = "21.05";
}
